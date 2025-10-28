"""
Functional dependencies
"""
def fd(src, dst):
  """
  make_fd(src, dst) creates an fd src -> dst
    src: string
    dst: string
  """
  return (frozenset(src.upper()), frozenset(dst.upper()))
def str_fd(fd):
  """
  str_fd(fd) returns a string representation of fd
    fd: from make_fd
  """
  src = ''.join(sorted(fd[0]))
  dst = ''.join(sorted(fd[1]))
  return f'{src} -> {dst}'
  
def fds(*args):
  """
  make_sigma(*args) creates a set of fd
    *args: a sequence of (src, dst)
  """
  res = frozenset()
  for src, dst in args:
    res |= {fd(src, dst)}
  return res
def str_fds(sigma):
  """
  str_sigma(sigma) returns a string representation of sigma
    sigma: from make_sigma
  """
  res, init = '{', True
  for fd in sigma:
    if init:
      init = False
      res += f'{str_fd(fd)}'
    else:
      res += f', {str_fd(fd)}'
  return res + '}'


"""
Algorithm
"""
def attr_close(attrs, sigma):
  """
  attr_close(attrs, sigma) returns the attribute closure of attrs w.r.t. sigma
    attrs: string
    sigma: from make_sigma
  """
  res, has = frozenset(attrs.upper()), True
  while has:
    has = False
    for src, dst in sigma:
      if src <= res and not (dst <= res):
        has = True
        res |= dst
  return res
