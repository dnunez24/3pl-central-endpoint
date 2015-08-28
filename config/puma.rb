#!/usr/bin/env puma

daemonize false
pidfile '/var/run/puma.pid'

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rackup DefaultRackup
bind 'tcp://0.0.0.0:9292'
environment ENV['RACK_ENV'] || 'development'
