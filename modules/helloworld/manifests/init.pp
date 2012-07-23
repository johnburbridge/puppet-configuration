class helloworld {
  notify { 'example':
    message => "A shout out from the $::environment environment!",
  }
}
