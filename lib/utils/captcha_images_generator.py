
# Import the following modules
from captcha.image import ImageCaptcha
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-i', '--ip')
parser.add_argument('-w', '--word')


args = parser.parse_args()
print(args.ip, args.word)

# Create an image instance of the given size
image = ImageCaptcha(width=280, height=90)


data = image.generate(args.word)

# write the image on the given file and save it
image.write(args.word, f'{args.ip}.png')
