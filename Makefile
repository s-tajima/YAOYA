check:
	/usr/local/bin/bundle exec bin/check

diff:
	/usr/local/bin/bundle exec bin/diff

record:
	/usr/local/bin/bundle exec bin/record

auto_trade:
	/usr/local/bin/bundle exec bin/auto_trade

cron:
	/usr/local/bin/bundle exec bin/check > /tmp/yaoya_result_check || true
	/usr/local/bin/bundle exec bin/diff  > /tmp/yaoya_result_diff  || true
	/usr/local/bin/bundle exec bin/record                          || true

