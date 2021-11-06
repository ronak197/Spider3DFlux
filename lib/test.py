def lambda_hand le r(event , context):
try:
#####
# Parse body paramete rs from request
#####
data json. loads (event [ ' body '1)
url
datal"ur"]
sennfo Webdriver- initialization
foS.path. exists ("/tmp/bin/ch romed river") True:
"**rerSubp rocess. run( "mkdir /tmp/bin', she ll=True)
scesOS. system ("cp ./ch romed river /tmp/bin/chromed rive r")
deeeee**OS. System (" cp ./headless-ch romium /tmp/bin/head less-ch romium")
deree**uOS. chmod ("/tmp/bin/ch romed river",00777)
os.chmod ("/ tmp/bin/head less-ch romium", 00777)
eeoptlons
options.binary_location
options.add_argument ("--head lesS")|
ptions. add_argument ("--disable-gpu")
options add_a rgument ("--sing le-process")
options. add_a rgument("--no-sandbox")
eeesmOptions. add_a rgument ("--disable-deV-shm-usage")
webd river. chrome0ptions )
'/tmp/bin/head less-ch romium'
**eer-Options . add_argument ("--window-size=1600x800"
driverwebdriver. Chrome (executable_path '/tmp/bin/ch romed river', ch rome_options options)
####*
# Execute Selenium script
#####
driver.get (url)
screenshotUrl takeAnd P rovideScreenshot (driver)