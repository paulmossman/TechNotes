**<span style="font-size:3em;color:black">Kafka</span>**
***

A distributed event streaming platform.

# Topic

A stream of data, identified by its name.  The sequence of Messages sent to a Topic is a Data Stream.

Split into a pre-determined number of Partitions.

**Immutable**: Messages written a Topic **cannot** be changed.  (They **can** be deleted, but Offsets cannot be re-used.)

Data is stored for a limited time (default: 1 week, but configurable.)

## Partitions

Messages written to a Topic are split into Partitions.

Messages are ordered **within** a Partition.  They are **not** ordered across Partitions.

# Message

aka Evemt, Record

Offset: The ordered ID of Messages in a Topic **Partition**.  i.e. Different Partitions can used the same Offset.

## Keys

Producers choose the Key for Message, can be null.

### Key = null

Messages with Key=null are sent **round-robin** to Partitions.

### Key != null

Messages with the **same** (non-null) Key value are always sent to the **same** Partition.  (Determined using a hash.)

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
- acks=1 → Wait for Leader ackknowledgement (limited data loss)
- acks=all → Wait for Leader **and all** ISRs ackknowledgement (no data loss)

# Consumer

Consumers read Message from Topics.

## Consumer Groups

Consumer Groups are identified by a unique ID.

Consumers in a Group each read from *different* Partitions.  (Though each *may* read from multiple Partitions.  A Consumer in the Group not reading from a Partition is considered *Inactive*. )

Consumer Group members cooperate to read from *all* Partitions in a Topic.

Multiple Consumer Groups **can** read from the same Topic.

## Commit Modes

The Offsets or processed Messages are comitted to the Kafka broker.  (Allows re-reading of a Message of the Consumer dies before processing it.  Stored in internal Kafka *__consumer_offsets* Topic.)

Java: By default, automatic At Least Once.

Can be done manually.

### At Least Once
- Committed after the Message is processed.
- The same Message may be processed multiple times, so processing must be idempotent.

### At Most Once
- Committed as soon as the Message is received.
- The Message can't be read again, so it's lost if processing fails.

### Exactly Once
?

# Kafka Cluster

Composed of multiple Brokers.

## Kafka Broker

A server, identified with a unique integer ID.

Clients connect to any single Broker then know how to connect to and Broker in the Cluster.

For each Topic Partition, exactly one Broker is the **Leader**.  Other Broker(s) can be an In-Sync Replica (ISR), and can become Leader if the original Leader Broker is lost.

### Replication Factor

The total number of data replicas, including the Leader.

Replication Factor = 1 (Leader) + # ISRs

_Topic Durability_: A Cluster with a Replication Factor of N can withstand the loss of N-1 Brokers without data loss.

# Zookeeper

Don't use it.  KRaft is the replacement, and has been production-ready since 3.3.1.

# Command Line

# kafka-console-consumer.sh

When used without ```--group```, a temporary Group is created.

To get all available Messages not yet committed by the Group, use ```--from-beginning```.  (When a temporary Group is used, there will of course not have been any commits for it yet.)

# Java SDK

https://mvnrepository.com/artifact/org.apache.kafka/kafka-clients - Official Low Level

https://mvnrepository.com/artifact/org.apache.kafka/kafka-streams - Official Streams

Quarkus: smallrye-reactive-messaging-kafka extension

# Connect from remote to Kafka Broker running on WSL2
In ```server.properties```:
```
listeners=REMOTE://172.18.152.219:9093,LOCAL://127.0.0.1:9092
advertised.listeners=REMOTE://172.18.152.219:9093,LOCAL://127.0.0.1:9092
listener.security.protocol.map=REMOTE:PLAINTEXT,LOCAL:PLAINTEXT
inter.broker.listener.name=LOCAL
```
See: https://issues.apache.org/jira/browse/KAFKA-9257 Allow listeners to bind on same port but different interfaces
