**<span style="font-size:3em;color:black">Kafka</span>**
***

A distributed event streaming platform.

# Components
1. Apache Kafka: back-end application, the Kafka Cluster
   - A Kafka Cluster is a collection of one or more Kafka Brokers.
2. Client Applications: two forms:
   - Kafka Connect: A data integration framework, supports Producer and Consumer.
   - Kafka Streams: A Java API to read data a Topic, process it, then write the result to another Topic (or another system.)

# Topic

A stream of data, identified by its name.  The sequence of Messages sent to a Topic is a Data Stream.

Split into a pre-determined number of Partitions.

**Immutable**: Messages written a Topic **cannot** be changed.  (They **can** be deleted, but Offsets cannot be re-used.)

Data is stored for a limited time (default: 1 week, but configurable.)

## Partitions

Messages written to a Topic are split into Partitions.

Messages are ordered **within** a Partition.  They are **not** ordered across Partitions.

# Message

aka Event, Record

Offset: The ordered ID of Messages in a Topic **Partition**.  i.e. Different Partitions can used the same Offset.

## Keys

Producers choose the Key for Message, can be null.

### Key = null

Messages with Key=null are sent **round-robin** to Partitions.

### Key != null

Messages with the **same** (non-null) Key value are sent to the **same** Partition, while you have **same number** of Partitions.  (Determined using a hash, which takes the number of Partitions into account.)

Choice of Key: For what entity do you want messages to be ordered for?

## Contents
- Key (can be null)
- Value (can be null)
- Compression Type (can be none)
- Headers (optional)
   - Key (presumably cannot be null?)
   - Value
- Partition + Offset
- Timestamp

# Producer

Producers write/send Messages to Topics.

## Producer Acknowledgements
- acks=0 → Don't wait for acknowledgement (possible data loss)
- acks=1 → Wait for Leader acknowledgement (limited data loss)
- acks=all/-1 → Wait for Leader **and all** ISRs acknowledgement (no data loss) (Default since Kafka 3.0)
   - Works well (in Production, RF>=3) with ```min.insync.replicas=2```, i.e. Make sure "all" ISRs is > 1.

## Producer Retires

Default "retries" since Kafka 2.1 is a very high number, but that's bounded by ```delivery.timeout.ms``` (2 minutes by default.)

## Idempotent Producer

Prevents duplicates of the same message when the Kafka Ack doesn't reach the Producer (e.g. due to a network error.)  Since Kafka 3.0 ```enable.idempotence``` is defaulted to ```true``` in the Producer properties.

## Compression of messages by Producer

```compression.type``` (the default is ```none```)

Faster to be sent over the network, and also stored compressed on Brokers resulting in less disk utilization.

## Producer Throughput

```linger.ms``` → How long to delay ending a batch to see if more records arrive.  Default is ```0``` (no delay.)  Tradeoff higher latency for higher throughput.

```batch.size``` → Control the upper bound on the size (in bytes) of batches.

# Consumer

Consumers read Message from Topics.

## Consumer Groups

Consumer Groups are identified by a unique ID.

Consumers in a Group each read from *different* Partitions.  (Though each *may* read from multiple Partitions.  A Consumer in the Group not reading from a Partition is considered *Inactive*. )

Multiple Consumer Groups **can** read from the same Topic.

### Rebalance

Consumer Group members cooperate to read from *all* Partitions in a Topic.  Kafka balances (and re-balances) which Partitions are read my which members.  Rebalance happens when:
- A Consumer joins the Group
- A Consumer leaves the Group
- A new Partition is added to the Topic

There are different rebalance (partition assignment) strategies:
- Eager: All Consumer stop for a period of time, and no guarantee that they resume with any of the same Partition(s) as before.
   - RangeAssignor (Kafka Consumer default)
   - RoundRobin
   - StickyAssignor
- Cooperative (aka Incremental): Reassign a small subset.  Consumers that aren't reassigned can continue processing.  Iterates, os can have multiple round of changes before done.
   - CooperativeStickyAssignor (Kafka Consumer best)

### Static Group Membership

Can prevent/delay rebalancing.  By default joining a groups results in a new "member ID", and triggers re-balancing.

But you can instead specify a "group member ID", which rebalances only if it's new.  When it leaves rebalancing is delayed for a (configurable) period of time.  If the same "group member ID" re-joins before timeout, then it gets the same partitions.  If not, then rebalancing occurs.

## Commit Modes

The Offsets or processed Messages are comitted to the Kafka broker.  (Allows re-reading of a Message of the Consumer dies before processing it.  Stored in internal Kafka *__consumer_offsets* Topic.)

A Commit applies to the Consumer Group.  i.e. One Consumer Group commits a message means that it won't re-read the message, but of course other Consumer Groups still can.

Java: By default, automatic (```anable.auto.commit=true```) At Least Once.  After ```auto.commit.interval.ms``` has elapsed, calling the next ```poll()``` triggers auto-commit of the previous batch.  (So don't call ```poll()``` again until the previous batch of messages have been processed.)

Alternatively: ```anable.auto.commit=false```, and manually commit the offsets.  i.e. If the processing of messages is asynchronous.

### At Least Once (But sometimes multiples, preferred)
- Committed after the Message is processed.
- The same Message may be processed multiple times, so processing must be [idempotent](https://en.wikipedia.org/wiki/Idempotence).
- Java Kafka Connect: Process all messages received by one KafkaConsumer.poll(), before calling poll() again.

### At Most Once (But soemtimes zero)
- Committed as soon as the Message is received.
- The Message can't be read again, so it's lost if processing fails.

### Exactly Once (ideal)
- Achieved only with Kafka→Kafka, and with the Transactional API
- Easy with the Kafka Streams API

# Kafka Cluster

Composed of multiple Brokers.

## Kafka Broker

A server, identified with a unique integer ID.

Clients connect to any single Broker then know how to connect to any Broker in the Cluster.

For each Topic Partition, exactly one Broker is the **Leader**.  Other Broker(s) can be an In-Sync Replica (ISR), and can become Leader if the original Leader Broker is lost.

### Replication Factor

The total number of data replicas, including the Leader.

Replication Factor = 1 (Leader) + # ISRs

_Topic Durability_: A Cluster with a Replication Factor of N can withstand the loss of N-1 Brokers without data loss.

Production: At least two, usually three, not more than four.

# Command Line

# kafka-console-consumer.sh

When used without ```--group```, a temporary Group is created.

To get all available Messages not yet committed by the Group, use ```--from-beginning```.  (When a temporary Group is used, there will of course not have been any commits for it yet.)

# APIs

## Official Low Level

https://mvnrepository.com/artifact/org.apache.kafka/kafka-clients - Producer and Consumer

### Graceful consumer shutdown

Exit gracefully, otherwise re-balancing will be delayed and re-starting the consumer will encounter delays in getting new messages.

```java

   // This causes consumer.poll() to throw a WakeupException (extends KafkaException)
   consumer.wakeup();
   
   // i.e. Call it from Runtime.getRuntime().addShutdownHook(...

```

## Extended APIs

### Kafka Connect
Solves:
- External "Source" → Kafka
- Kafka → External "Sink"

100s of pre-written "Connectors" to various existing external systems.  e.g. PostgreSQL, JDBC, HTTP, HTML SSE API, AWS Redshift, AWS S3, ActiveMQ, etc.  See: https://www.confluent.io/hub

#### Change Data Capture (CDC)

Monitor a DB for changes → Events

### Kafka Streams

Solves Kafka→Kafka. i.e. Transformation of data

Official: https://mvnrepository.com/artifact/org.apache.kafka/kafka-streams

Quarkus: smallrye-reactive-messaging-kafka extension, and [Overview](https://quarkus.io/guides/kafka)

### KSQL

Perform SQL queries on Kafka data.

## Schema Registry

Schemas change over time.  Kafka Brokers don't verify/parse messages.  Producers and Consumers use the Schema Registry to maintain a common data format.

[Apache Avro](https://avro.apache.org/) is the data serialization framework.  (Others are supported.)  Used to define a binary format, and map it.

How it works: Producer send the schema to the Schema Registry, then send avro data to Kafka (smaller, since it doesn't contain the schema.  Consumers then retrieve the corresponding schema from the Schema Registry, and then can parse the binary data.

Free under Confluent Community License (has restrictions, not open-source, has Enterprise version): [Confluent Schema Registry](https://www.confluent.io/product/confluent-platform/data-compatibility/)

[AWS Glue Schema Registry](https://docs.aws.amazon.com/glue/latest/dg/schema-registry.html)

# Misc

## Log Compaction

Optionally compact multiple Active Segments into fewer Active Segments, by keeping only the latest message for each Key.

Useful when you only care about the last message for each Key.  Only affects Consumers that are "behind", e.g. read "from beginning".  A "realtime" Consumer will still see all the messages.

## Java Unit Testing

https://kafka.apache.org/documentation/streams/developer-guide/testing.html


## Connect from remote to Kafka Broker running on WSL2
In ```server.properties```:
```
listeners=REMOTE://172.18.152.219:9093,LOCAL://127.0.0.1:9092
advertised.listeners=REMOTE://172.18.152.219:9093,LOCAL://127.0.0.1:9092
listener.security.protocol.map=REMOTE:PLAINTEXT,LOCAL:PLAINTEXT
inter.broker.listener.name=LOCAL
```
See: https://issues.apache.org/jira/browse/KAFKA-9257 Allow listeners to bind on same port but different interfaces

## Zookeeper

Don't use it.  KRaft is the replacement, and has been production-ready since 3.3.1.

## Multi-Cluster Replication

For geographically distributed sites, where Kafka's Cluster replication would be too slow/costly.  Just a Producer and a Consumer to copy the data, but does ***not*** get the same Offsets.   There are a number of open-source implementations, including MirrorMaker 2 which is part of base Kafka.