#!/usr/bin/env python3

import sys
import json
import requests

TEST_FILE = "/tmp/test-wigo-to-slack.json"
URL_SLACK = ""


def main(argv):
    if len(argv) < 2:
        print("Missing arguments!")
        sys.exit(1)

    try:
        notification = json.loads(sys.argv[1])
    except AttributeError:
        print("Wrong json format to load as argv[1]")
        sys.exit(2)

    slack_data = dict()
    slack_data['text'] = notification['Message']
    if notification['NewProbe']['Status'] >= 250:
        title = ":fire: WIGO noticed an issue"
    else:
        title = ":white_check_mark: WIGO, all is back to normal"

    slack_data['blocks'] = [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": title,
                "emoji": True
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "{}\nOn: {}".format(notification['Message'], notification['Date']),
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "Summary: {}".format(notification['Summary']),
            }
        }
    ]
    requests.post(URL_SLACK, json=slack_data)


main(sys.argv)
