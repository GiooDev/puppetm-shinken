# shinken

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with shinken](#setup)
    * [Beginning with shinken](#beginning-with-shinken)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
    * [TODO List](#todo-list)

## Description

Shinken is a monitoring framework. It's a Python Nagios Core total rewrite
enhancing flexibility and large environment management.

This module will manage installation of shinken daemons and theirs associated
configuration.

## Setup

### Beginning with shinken

Here is the very basic steps to install and start all shinken-daemons with
default configuration:

```puppet
include shinken

shinken::daemon { 'broker': }
shinken::daemon { 'poller': }
shinken::daemon { 'reactionner': }
shinken::daemon { 'receiver': }
shinken::daemon { 'scheduler': }
```

## Usage

Here is how to start all shinken-daemons with class shinken and to specify
default parameters for all daemons:

```puppet
class { 'shinken':
  daemons         => {
    'broker'      => {},
    'poller'      => {},
    'reactionner' => {},
    'receiver'    => {},
    'scheduler'   => {
      'port'          => '7768',
      'use_local_log' => '0',
    },
  },
  daemons_default => {
    'user'  => 'shinken',
    'group' => 'shinken',
  },
}
```

This could be really convenient when used with hiera:

```puppet
include shinken
```
and
```
---
shinken::daemons:
  broker: {}
  poller: {}
  reactionner: {}
  receiver: {}
  scheduler:
    port: 7768
    use_local_log: 0
shinken::daemons_default:
  user: 'shinken'
  group: 'shinken'
```

## Limitations

The shinken module has been tested on RedHat distribution. Currently it only
support distribution with systemd.

Tested with puppet >= 3.8.

Patches to support any of these (or other) missing features are welcome.

## Development

Currently it only manage shinken-daemons (except arbiter).

### TODO LIST
* Manage shinken-arbiter with .cfg creation for all daemons.
* Support other distribution.
* Add automatic tests.

Contributions are welcome :)
