return {
  name = "tape",
  version = "0.1.0",
  description = "TAP producer for luvit",
  repository = {
    url = "https://github.com/virgo-agent-toolkit/luvit-tape.git",
  },
  author = {
    name = "Song Gao",
    email = "song@gao.io",
    url = "https://song.gao.io",
  },
  contributors = {
    {
      name = "Robert Chiniquy",
      email = "robert.chiniquy@rackspace.com",
      url = "https://robert-chiniquy.github.io/",
    },
    {
      name = "Ryan Phillips",
      email = "ryan.phillips@rackspace.com",
      url = "http://trolocsis.com/",
    },
  },
  licenses = {"Apache-2.0"},
  dependencies = {
    "stream",
  },
  main = 'init.lua',
}
