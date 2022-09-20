# Overlay Style Manager
This Openplanet plugin lets you easily install and create custom styles for the Openplanet overlay.

![](https://openplanet.dev/imgu/1662755116_b1290a1b32a160bd0d20296bdd818c8c89a4ce84.jpg)

## Submitting styles to the index
To submit your own style to the index, either create an issue on Github or share your style on the
Discord. Note that your style must adhere to a specific format in order to be installable.

Your style must be in a Github repository. (I might add support for other services later.) You must
have an `info.json` file in the root of your repository. Here's an example:

```json
{
	"description": "Example style for the Openplanet overlay.",
	"screenshot": "Screenshot.jpg",
	"style": "Example.toml"
}
```

The `screenshot` and `style` keys are relative paths within your repository. In the example above,
this means you need a `Screenshot.jpg` and `Example.toml` in the root of your repository.

You can have multiple screenshots as well by using the `screenshots` key as an array:

```json
"screenshots": [ "...", "..." ]
```

If you have a collection of multiple styles, you can also use the `styles` array to put more than
one style:
```json
{
	"styles": [
		{
			"name": "Example in red",
			"description": "This is my style in red.",
			"style": "ExampleRed.toml"
		},
		{
			"name": "Example in blue",
			"description": "This is my style in blue.",
			"style": "ExampleBlue.toml"
		}
	]
}
```

You may also have sub-styles:
```json
{
	"styles": [
		{
			"name": "Colorful",
			"styles": [
				{
					"description": "Example in red",
					"name": "Red",
					"style": "ExampleRed.toml"
				},
				{
					"description": "Example in blue",
					"name": "Blue",
					"style": "ExampleBlue.toml"
				}
			]
		},
		{
			"name": "Black and white",
			"styles": [
				{
					"description": "Example in white",
					"name": "White",
					"style": "ExampleWhite.toml"
				},
				{
					"description": "Example in black",
					"name": "Black",
					"style": "ExampleBlack.toml"
				}
			]
		}
	]
}
```
