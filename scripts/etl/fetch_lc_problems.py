import requests
import json

import datetime

# TODO: To get leetcode progression data, we need to have login information
# import dotenv
# dotenv.load_dotenv()

current_datetime = datetime.datetime.now()
current_datetime_str = current_datetime.strftime('%Y-%m-%d_%H-%M-%S')

script = """
splash:go(args.url)
splash:wait(5)

local get_json = splash:jsfunc([[
    function() {
        return JSON.stringify(document.body.innerText);
    }
]])

local json = get_json()
return {json=json}
"""

def fetch_lc_problems():
    resp = requests.post('https://splash.tearsjobs.careers/run', json={
        'lua_source': script,
        'url': 'https://leetcode.com/api/problems/algorithms/'
    })

    _data = json.loads(resp.json()['json'])
    _data = json.loads(_data)
    return _data


if __name__ == '__main__':
    data = fetch_lc_problems()
    # print(data)
    with open(f'lc_problems_{current_datetime_str}.json', 'w') as f:
        json.dump(data, f)
