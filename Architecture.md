**<span style="font-size:3em;color:black">Architecture</span>**
***

# Databases & Storage

NoSQL and Sharding helps the scaling problem.  Denormalization (redundant data) is key.

## Data Lakes - for OLAP

## ACID compliance → Atomicity, Consistency, Isolation, and Durability

## CAP theorem → Consistency, Availability, Partition-tolerance

PACELC theorem → CAP else (when running normally)  Latency or Consistency loss

## Caching:
- LRU (least recently used)
- LFU (least frequently used)
- FIFO (first in, first out.)

## Geo-Resilience

## HDFS - Hadoop Distributed Filesystem


## Raft Consensus Algorithm

https://raft.github.io/

Used by [IBM/Hashicorp Consul](https://www.consul.io/)

An excellent tutorial: https://thesecretlivesofdata.com/raft/

# Big Data

Message Queues - e.g. AWS SNS