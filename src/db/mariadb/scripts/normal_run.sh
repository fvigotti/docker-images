#!/bin/sh
mysql_pre_start_action() {
  # Cleanup previous sockets
  rm -f /run/mysqld/mysqld.sock
}
