from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import sys
import ST7735


# Create ST7735 LCD display class object and set pin numbers and display hardware information.
disp = ST7735.ST7735(
    dc=24,
    cs=ST7735.BG_SPI_CS_BACK,
    rst=25,
    port=0,
    width=122,
    height=160,
    rotation=270
)

# Initialize display.
disp.begin()

WIDTH = disp.width
HEIGHT = disp.height

img = Image.new('RGB', (WIDTH, HEIGHT), color=(0, 0, 0))

draw = ImageDraw.Draw(img)

font = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf", 12)
# Initialize a secondary text with the empty string
text2 = ""

# Print test-output on the display if n oargument is given
if len(sys.argv) == 1:
	text = "Temperature:\nHumidity:\nUV:\nRain:\nLight:"
	text2 = "20°C\n50 %\n42\nyes\nOn"
# Print the argument if only one is given
elif len(sys.argv) == 2:
    text = sys.argv[1]
# If 2 arguments are given use the second as the secondary text
elif len(sys.argv) == 3:
	text = sys.argv[1]
	text2 = sys.argv[2]
# For any other number of arguments draw them in one line each
else:
	text = ''.join(i + "\n" for i in sys.argv[1:])

# Print both texts, with the secondary one starting with an 100 px offset
draw.text((10, 10), text, font=font, fill=(255, 255, 255))
draw.text((110, 10), text2, font=font, fill=(255, 255, 255))
disp.display(img)
