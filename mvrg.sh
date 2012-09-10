#!/bin/bash

# Minimum Viable Redis Graphite 
# David Lutz 2012-09-10
# run with arguments host port password
# you'll need redis-cli installed 
# run from cron like this
# */5	*	*	*	*	/opt/mvrg.sh redishost 6379 Password1  | nc -w 2 your.graphite.server 2003

redishost=$1
redisport=$2
redispassword=$3
friendlyhost=`echo $redishost | sed 's/\./_/g'`

now=`date -u +"%s"`

out=`redis-cli -h $redishost -p $redisport -a $redispassword info | grep "db0:keys=" | awk -F '=' '{print $2}' | awk -F ',' '{print $1}'`
echo "redis.$friendlyhost.keys $out $now" 

for i in uptime_in_seconds lru_clock used_cpu_sys used_cpu_user used_cpu_sys_children used_cpu_user_children connected_clients connected_slaves client_longest_output_list client_biggest_input_buf blocked_clients used_memory used_memory_rss mem_fragmentation_ratio use_tcmalloc loading aof_enabled changes_since_last_save bgsave_in_progress bgrewriteaof_in_progress total_connections_received total_commands_processed expired_keys evicted_keys keyspace_hits keyspace_misses hash_max_zipmap_entries hash_max_zipmap_value pubsub_channels pubsub_patterns vm_enabled 
do
  out=`redis-cli -h $redishost -p $redisport -a $redispassword info | grep "$i:" | awk -F ':' '{print $2}' | tr -d '\r' `
  echo "redis.$friendlyhost.$i $out $now"
done
