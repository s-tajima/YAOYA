check:
	/usr/local/bin/bundle exec bin/check

diff:
	/usr/local/bin/bundle exec bin/diff

record:
	/usr/local/bin/bundle exec bin/record

cron:
	/usr/local/bin/bundle exec bin/check > /tmp/yaoya_result_check;
	/usr/local/bin/bundle exec bin/diff  > /tmp/yaoya_result_diff;
	/usr/local/bin/bundle exec bin/record

