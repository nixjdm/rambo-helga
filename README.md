# A Rambo Helga project

This repo will create allow you to create a VM with Rambo that will run Helga. By default it will run on a ec2 t2-micro, but this is configurable. To change the target, just override change the `rambo.conf` or override it with a `my_rambo.conf`.

This puts helga in a Python 2.7 env made by conda, with pip 9.0.3, and supplies a new requirements.txt for Helga that actually works. The helga project and plugins could use some love to get these things compatible with modern tooling, but as is, this will work.

This requires a `my_settings.py` to run with real settings. Create that to override Helga's defaults. E.g.:

```python
# my_settings.py

SERVER = {
    'HOST': 'irc.mydomain.com',
    'PORT': 6667,
    'TYPE': 'irc',
    'SSL': True,
}

CHANNEL_LOGGING = True
TWITTER_CONSUMER_KEY = 'aaaaaaaaaaaaaaa'
TWITTER_CONSUMER_SECRET = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
TWITTER_ACCESS_TOKEN = '999999999-YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
TWITTER_ACCESS_SECRET = 'fffffffffffffffffffffffffffffffffffffffffffff'
```

Pre-reqs:

1. Install rambo `pip install rambo` and it's deps.
2. Load your env vars for aws (or wherever): `. auth/keys/aws.env.sh`
3. Make sure you've made the appropriate security groups so that helga can see the world. Modify your rambo config if you need to.

To run:

1. Make a `my_settings.py` (see above)
2. `rambo up; rambo ssh`
3. (now in an ssh session) `screen_helga` to Start helga in a screen session
4. Type "Ctrl-a d" to detach from the screen session. Now Helga's running!

Feel free to close the ssh session and not worry about it anymore.

If something is ever amiss, you can `ssh` back in and run `sreen -r helga` to attach to the screen session. You might be able to see debug info there.

If anything is wrong, it's fairly likely that you need to (re)start the mongo db service. Do this with:
```bash
sudo service mongod restart
```
