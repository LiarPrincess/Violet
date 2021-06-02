import os
import re
import sys
from bs4 import BeautifulSoup


# Config

class Config:
    def __init__(self,
                 html_file, output_file,
                 type_url_prefix, property_url_prefix, function_url_prefix,
                 expected_count):
        self.html_file = html_file
        self.output_file = output_file
        self.type_url_prefix = type_url_prefix
        self.property_url_prefix = property_url_prefix
        self.function_url_prefix = function_url_prefix
        self.expected_count = expected_count


builtins_config = Config(
    html_file='site-builtins.html',
    output_file='result-builtins.swift',
    type_url_prefix='https://docs.python.org/3/library/stdtypes.html',
    property_url_prefix='https://docs.python.org/3/library/functions.html',
    function_url_prefix='https://docs.python.org/3/library/functions.html',
    expected_count=14 * 5 - 1,  # from the table at the top of the site
)

sys_config = Config(
    html_file='site-sys.html',
    output_file='result-sys.swift',
    type_url_prefix='https://docs.python.org/3.7/library/sys.html',
    property_url_prefix='https://docs.python.org/3.7/library/sys.html',
    function_url_prefix='https://docs.python.org/3.7/library/sys.html',
    expected_count=-1,
)


# Print

def in_current_directory(filename: str):
    current_file = __file__
    current_dir = os.path.dirname(current_file)
    return os.path.join(current_dir, filename)

# HTML example:
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


def print_module_functions(config: Config):
    count = 0
    html_path = in_current_directory(config.html_file)
    output_path = in_current_directory(config.output_file)

    with open(html_path, 'r') as reader:
        html = reader.read()
        soup = BeautifulSoup(html, features='html.parser')

        sys.stdout = open(output_path, 'w')

        for dl in soup.body.find_all('dl'):
            dt_codes = dl.dt.find_all('code')
            if not dt_codes:
                continue

            name = ''.join(map(lambda c: c.get_text(), dt_codes)).replace('sys.', '')

            signature = dl.dt.get_text().strip()
            signature = re.sub(r'\n\s+', ' ', signature).replace('¶', '')

            link = dl.dt.find("a", class_="headerlink")

            # property
            if dl['class'] == ['data']:
                print(f'// sourcery: pyproperty = {name}')
                print(f'/// {signature}')
                if link:
                    link = config.property_url_prefix + link['href']
                    print(f'/// See [this]({link}).')

                name = name[0].upper() + name[1:]
                print(f'public func get{name}() -> PyObject {{')
                print(f'  return self.unimplemented')
                print(f'}}')

            # function
            elif dl['class'] == ['function']:
                print(f'// sourcery: pymethod = {name}')
                print(f'/// {signature}')
                if link:
                    link = config.function_url_prefix + link['href']
                    print(f'/// See [this]({link}).')

                print(f'public func {name}() -> PyObject {{')
                print(f'  return self.unimplemented')
                print(f'}}')

            # class
            elif dl['class'] == ['class']:
                print(f'// sourcery: pytype = {name}')
                print(f'/// {signature}')
                print(f'internal let {name}: PyType')

            else:
                print('Missing:', dl['class'])

            print()
            count += 1

    sys.stdout = sys.__stdout__

    if config.expected_count != -1 and count != config.expected_count:
        print(f'Missing {config.expected_count - count} functions!')
        sys.exit(-1)


# Main

if __name__ == '__main__':
    print_module_functions(builtins_config)
    print_module_functions(sys_config)
