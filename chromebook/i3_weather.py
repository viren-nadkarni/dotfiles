#!/usr/bin/env python3

import requests
import json

resp = requests.get("https://api.forecast.io/forecast/089a6629f547f7c0545b3e3506fb3cb4/57.69,11.98?units=si")
j = json.loads(resp.text)

#print('{} {}°C'.format(j['currently']['summary'], round(j['currently']['apparentTemperature'])))
print('{}°C ({})'.format(round(j['currently']['apparentTemperature']), j['hourly']['summary'].strip('.')))

