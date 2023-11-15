<source>
  @type tail
  path C:/ProgramData/nomad/data/alloc/*/alloc/logs/*_check-fonts.stdout.*
  pos_file c:/opt/pos_files/nomad_logs.pos
  tag nomad-test-stdout.logs
  path_key filepath
  <parse>
     @type regexp
     expression /^\[\d{2}:\d{2}:\d{2} \w{3}\] (?<message>.*)$/
  </parse>
</source>

<filter nomad-test-stdout.logs>
  @type record_transformer
  enable_ruby
  <record>
    allocator ${record["filepath"] ? record["filepath"].split('/')[-4] : nil}
    log_filename ${record["filepath"] ? record["filepath"].split('/')[-1] : nil}
    job_name ${record["filepath"] ? record["filepath"].split('/')[-1].split('_')[0] : nil}
    task_name ${record["filepath"] ? record["filepath"].split('/')[-1].split('_')[1] : nil}
    job_namespace ${record["filepath"] ? record["filepath"].split('/')[-1].split('_')[2].split('.')[0] : nil}
    extension ${record["filepath"] ? record["filepath"].split('/')[-1].split('.')[1..-1].join('.') : nil}
  </record>
</filter>

<match nomad-test-stdout.logs>
  @type    {{ key "elasticsearch/TYPE" }}
  host     {{ key "elasticsearch/HOST" }}
  path     {{ key "elasticsearch/PATH" }}
  port     {{ key "elasticsearch/PORT" }}
  user     {{ key "elasticsearch/USER" }}
  password {{ key "elasticsearch/PASSWORD" }}
  index_name ${tag}
  flush_interval 1s
  type_name fluentd
  logstash_format true
  logstash_prefix nomad-test
</match>

<match fluent.**>
  @type null
</match>