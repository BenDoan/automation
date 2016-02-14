#!/usr/bin/env python

import logging
import subprocess
import os

import requests
import toml

ON_STATE = "on"
OFF_STATE = "off"

class LightManager(object):
    def __init__(self, config):
        self.config = config
        logging.basicConfig(level=logging.getLevelName(config['log_level']))

    def run(self):
        logging.info("on")
        with open(self.config['state_file'], "a+") as f:
            f.seek(0)

            last_state = f.read().strip()
            is_chromecast_on = self.is_chromecast_on()

            logging.debug("Last state was: %s", last_state)
            logging.debug("Chromecast is on: %s", is_chromecast_on)
            if is_chromecast_on and last_state != ON_STATE:
                self.turn_light_off()
            elif not is_chromecast_on and last_state != OFF_STATE:
                self.turn_light_on()
            else:
                logging.debug("NOOP")

            f.seek(0)
            f.truncate()

            f.write(ON_STATE if is_chromecast_on else OFF_STATE)

    def turn_light_on(self):
        logging.info("Turning light on")
        requests.get(self.config['light_url_on'])

    def turn_light_off(self):
        logging.info("Turning light off")
        requests.get(self.config['light_url_off'])

    def is_chromecast_on(self):
        resp = os.system('ping -W 1 -c 1 {} > /dev/null 2>&1'.format(self.config['chromecast_url']))
        return resp == 0

if __name__ == "__main__":
    with open("config.toml") as f:
        LightManager(toml.load(f)).run()
