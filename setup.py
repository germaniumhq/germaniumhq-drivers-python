from setuptools import setup


with open('README.rst') as readme_file:
    readme = readme_file.read()

setup(
    name='germaniumdrivers',
    version='1.7.14',
    description='The germanium project: Selenium WebDriver testing API that doesn\'t disappoint. (tested WebDrivers package)',
    long_description = readme,
    author='Bogdan Mustiata',
    author_email='bogdan.mustiata@gmail.com',
    license='BSD',

    install_requires=[],
    packages=[
        'drivers.binary.chrome.linux.32',
        'drivers.binary.chrome.linux.64',
        'drivers.binary.chrome.mac.32',
        'drivers.binary.chrome.win.32',
        'drivers.binary.firefox.linux.64',
        'drivers.binary.firefox.mac.32',
        'drivers.binary.firefox.win.32',
        'drivers.binary.ie.win.32',
        'drivers.binary.ie.win.64',
    ],
    package_data={
        'drivers.binary.chrome.linux.32' : ['chromedriver'],
        'drivers.binary.chrome.linux.64' : ['chromedriver'],
        'drivers.binary.chrome.mac.32' : ['chromedriver'],
        'drivers.binary.chrome.win.32' : ['chromedriver.exe'],
        'drivers.binary.firefox.linux.64' : ['geckodriver'],
        'drivers.binary.firefox.mac.32' : ['geckodriver'],
        'drivers.binary.firefox.win.32' : ['geckodriver.exe'],
        'drivers.binary.ie.win.32' : ['IEDriverServer.exe'],
        'drivers.binary.ie.win.64' : ['IEDriverServer.exe']
    }
)

