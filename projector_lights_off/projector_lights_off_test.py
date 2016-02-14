#!/usr/bin/env python

import responses
import toml
import unittest

from unittest.mock import MagicMock

import projector_lights_off
from projector_lights_off import LightManager

class TestLightManager(unittest.TestCase):
    def setUp(self):
        with open("config.toml") as f:
            self.config = toml.load(f)

        self.light_manager = LightManager(self.config)

    def teardown(self):
        open(self.config['state_file'], "w+").close()

    @responses.activate
    def test_chromecast_on(self):
        self.light_manager.is_chromecast_on = MagicMock(return_value=True)
        responses.add(responses.GET,
                        self.config['light_url_off'],
                        body="on",
                        status=200)

        self.light_manager.run()

    @responses.activate
    def test_chromecast_off(self):
        self.light_manager.is_chromecast_on = MagicMock(return_value=False)
        responses.add(responses.GET,
                        self.config['light_url_on'],
                        body="on",
                        status=200)

        self.light_manager.run()

if __name__ == '__main__':
    unittest.main()
