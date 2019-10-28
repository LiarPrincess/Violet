import re
from bs4 import BeautifulSoup

expected_count = 14 * 5 - 1
stdtypes_url = 'https://docs.python.org/3/library/stdtypes.html'
functions_url = 'https://docs.python.org/3/library/functions.html'

count = 0
with open('./Scripts/generate-builtins.html', 'r') as reader:
  html = reader.read()
  soup = BeautifulSoup(html, features = 'html.parser')

  for dl in soup.body.find_all('dl'):
    dt_codes = dl.dt.find_all('code')
    if not dt_codes:
      continue

    name = ''.join(map(lambda c: c.get_text(), dt_codes))

    signature = dl.dt.get_text().strip()
    signature = re.sub(r'\n\s+', ' ', signature).replace('¶', '')

    link = dl.dt.find("a", class_="headerlink")
    link = functions_url + (link['href'] if link else '')

    if dl['class'] == ['function']:
      print(f'// sourcery: pymethod: {name}')
      print(f'/// {signature}')
      if link:
        print(f'/// See [this]({link}).')

      print(f'public func {name}() -> PyObject {{')
      print(f'  return self.unimplemented')
      print(f'}}')

    elif dl['class'] == ['class']:
      print(f'// sourcery: pytype: {name}')
      print(f'/// {signature}')
      print(f'internal let {name}: PyType')

    else:
      print('Something missing?')

    print()
    count += 1

if count != expected_count:
  print(f'Missing {expected_count - count} functions!')


# Examples:
# <dl class="function">
#   <dt id="abs">
#     <code class="descname">abs</code>
#     <span class="sig-paren">(</span>
#     <em>x</em>
#     <span class="sig-paren">)</span>
#     <a class="headerlink" href="#abs" title="Permalink to this definition">¶</a>
#   </dt>
#   <dd>
#     <p>
#       Return the absolute value of a number. The argument may be an
#       integer or a floating point number. If the argument is a complex number, its
#       magnitude is returned. If
#       <em>x</em>
#       defines
#       <a class="reference internal" href="../reference/datamodel.html#object.__abs__" title="object.__abs__">
#         <code class="xref py py-meth docutils literal notranslate">
#           <span class="pre">__abs__()</span>
#         </code>
#       </a>,
#       <code class="docutils literal notranslate">
#         <span class="pre">abs(x)</span>
#       </code>
#       returns
#       <code class="docutils literal notranslate">
#         <span class="pre">x.__abs__()</span>
#       </code>.
#     </p>
#   </dd>
# </dl>

# <dl class="class">
#   <dt id="bool">
#     <em class="property">class </em>
#     <code class="descname">bool</code>
#     <span class="sig-paren">(</span>
#     <span class="optional">[</span>
#     <em>x</em>
#     <span class="optional">]</span>
#     <span class="sig-paren">)</span>
#     <a class="headerlink" href="#bool" title="Permalink to this definition">¶</a>
#   </dt>
#   <dd>
#     <p>
#       Return a Boolean value, i.e. one of
#       <code class="docutils literal notranslate">
#         <span class="pre">True</span>
#       </code>
#       ...
#       <div class="versionchanged" id="index-0">
#       <p>
#         <span class="versionmodified changed">Changed in version 3.7: </span>
#         <em>x</em>
#         is now a positional-only parameter.
#       </p>
#     </div>
#   </dd>
# </dl>
