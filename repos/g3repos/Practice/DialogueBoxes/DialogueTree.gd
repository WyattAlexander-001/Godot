extends PanelContainer

var dialogue = {
	0: {
		"text": "Hey, [i]wake up![/i] It's time to make video games.",
		"expression": "neutral",
		"buttons":
		{
			"Let me sleep a little longer": 2,
			"Let's do it!": 1,
		}
	},
	1: {
		"text": "Great! Your first task will be to write a [b]dialogue tree[/b].",
		"expression": "neutral",
		"buttons":
		{
			"I'm not sure if I'm ready, but I will do my best": 3,
			"No, let me go back to sleep": 2,
		}
	},
	2: {
		"text": "Oh, come on! It'll be fun.",
		"expression": "sad",
		"buttons":
		{
			"No, really, let me go back to sleep": 0,
			"Alright, I'll try": 3,
		}
	},
	3: {
		"text": "That's the spirit! You can do it!\n[wave][b]YOU WIN[/b][/wave]",
		"expression": "happy",
		"buttons": {}
	}
}
