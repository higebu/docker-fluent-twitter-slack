#!/usr/bin/dumb-init /bin/sh

USER=`whoami`

# edit fluent.conf
twitter_consumer_key=${TWITTER_CONSUMER_KEY:?"TWITTER_CONSUMER_KEY is required"}
twitter_consumer_secret=${TWITTER_CONSUMER_SECRET:?"TWITTER_CONSUMER_SECRET is required"}
twitter_access_token=${TWITTER_ACCESS_TOKEN:?"TWITTER_ACCESS_TOKEN is required"}
twitter_access_token_secret=${TWITTER_ACCESS_TOKEN_SECRET:?"TWITTER_ACCESS_TOKEN_SECRET is required"}
slack_webhook_url=${SLACK_WEBHOOK_URL?"SLACK_WEBHOOK_URL is required"}
slack_channel=${SLACK_CHANNEL?"SLACK_CHANNEL is required"}

timeline="${TWITTER_TIMELINE:-sampling}"
slack_username="${SLACK_USERNAME:-fluent}"
default_icon=':ghost:'
icon="${SLACK_ICON_EMOJI:-$default_icon}"
flush_interval="${SLACK_FLUSH_INTERVAL:-60s}"

sed -i "s/TWITTER_CONSUMER_KEY/$twitter_consumer_key/" /fluentd/etc/fluent.conf
sed -i "s/TWITTER_CONSUMER_SECRET/$twitter_consumer_secret/" /fluentd/etc/fluent.conf
sed -i "s/TWITTER_ACCESS_TOKEN_SECRET/$twitter_access_token_secret/" /fluentd/etc/fluent.conf
sed -i "s/TWITTER_ACCESS_TOKEN/$twitter_access_token/" /fluentd/etc/fluent.conf
sed -i "s/TWITTER_TIMELINE/$timeline/" /fluentd/etc/fluent.conf
if [ -n "$TWITTER_KEYWORD" ]; then
  sed -i "s/TWITTER_KEYWORD/$TWITTER_KEYWORD/" /fluentd/etc/fluent.conf
else
  sed -i "/TWITTER_KEYWORD/d" /fluentd/etc/fluent.conf
fi
if [ -n "$TWITTER_FOLLOW_IDS" ]; then
  sed -i "s/TWITTER_FOLLOW_IDS/$TWITTER_FOLLOW_IDS/" /fluentd/etc/fluent.conf
else
  sed -i "/TWITTER_FOLLOW_IDS/d" /fluentd/etc/fluent.conf
fi
if [ -n "$TWITTER_LANG" ]; then
  sed -i "s/TWITTER_LANG/$TWITTER_LANG/" /fluentd/etc/fluent.conf
else
  sed -i "/TWITTER_LANG/d" /fluentd/etc/fluent.conf
fi
if [ -n "$TWITTER_OUTPUT_FORMAT" ]; then
  sed -i "s/TWITTER_OUTPUT_FORMAT/$TWITTER_OUTPUT_FORMAT/" /fluentd/etc/fluent.conf
else
  sed -i "/TWITTER_OUTPUT_FORMAT/d" /fluentd/etc/fluent.conf
fi
if [ -n "$TWITTER_FLATTEN_SEPARATOR" ]; then
  sed -i "s/TWITTER_FLATTEN_SEPARATOR/$TWITTER_FLATTEN_SEPARATOR/" /fluentd/etc/fluent.conf
else
  sed -i "/TWITTER_FLATTEN_SEPARATOR/d" /fluentd/etc/fluent.conf
fi
sed -i "s#SLACK_WEBHOOK_URL#$slack_webhook_url#" /fluentd/etc/fluent.conf
sed -i "s/SLACK_USERNAME/$slack_username/" /fluentd/etc/fluent.conf
sed -i "s/SLACK_CHANNEL/$slack_channel/" /fluentd/etc/fluent.conf
sed -i "s/SLACK_ICON_EMOJI/$icon/" /fluentd/etc/fluent.conf
sed -i "s/SLACK_FLUSH_INTERVAL/$flush_interval/" /fluentd/etc/fluent.conf

exec fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins "${FLUENTD_OPT}"
