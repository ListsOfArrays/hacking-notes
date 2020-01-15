# 7) Get Access To The Steam Tunnels
## Prompt
Help Krampus beat the Frido Sleigh contest. For hints on achieving this objective, please talk with Alabaster Snowball in the Speaker Unpreparedness Room.
## Secondary Prompt
Hello there! I’m Krampus Hollyfeld.
I maintain the steam tunnels underneath Elf U,
Keeping all the elves warm and jolly.
Though I spend my time in the tunnels and smoke,
In this whole wide world, there's no happier bloke!
Yes, I borrowed Santa’s turtle doves for just a bit.
Someone left some scraps of paper near that fireplace, which is a big fire hazard.
I sent the turtle doves to fetch the paper scraps.
But, before I can tell you more, I need to know that I can trust you.
Tell you what – if you can help me beat the Frido Sleigh contest (Objective 8), then I'll know I can trust you.
The contest is here on my screen and at fridosleigh.com.
No purchase necessary, enter as often as you want, so I am!
They set up the rules, and lately, I have come to realize that I have certain materialistic, cookie needs.
Unfortunately, it's restricted to elves only, and I can't bypass the CAPTEHA.
(That's Completely Automated Public Turing test to tell Elves and Humans Apart.)
I've already cataloged 12,000 images and decoded the API interface.
Can you help me bypass the CAPTEHA and submit lots of entries?
## Solve Process
1. This one was terrible, mostly due to configuration errors by me. In my brilliance I made sure to have the wrong version of python installed (3.8) which TensorFlow was incompatible with in pip. So, I decided to compile it from source. Long story short it didn't work and cost a lot of time. Eventually I agreed that using the pip package for TensorFlow 1.15 was needed instead of TensorFlow 2.
1. I decided to spice things up a bit (oh no) and add a "Random Noise" classification with about 30 images. These may have improved the result or not, but regardless, the original Inception net was too slow to use, and failed to do the challenge in time. So, I switched to https://tfhub.dev/google/imagenet/mobilenet_v1_100_224/quantops/feature_vector/3, following the advice of https://hackernoon.com/creating-insanely-fast-image-classifiers-with-mobilenet-in-tensorflow-f030ce0a2991. This worked in the time needed, but kept failing to identify the correct number of images... with some debugging there was an additional "," at the end that was screwing the post up.
1. Now that we entered 101 times, we won the contest & got an email sent to us with the flag.
1. This makes Krampus happy, and we get a prompt for challenge 9 (which we've already solved by this point haha)

## New prompt:
You did it! Thank you so much. I can trust you!
To help you, I have flashed the firmware in your badge to unlock a useful new feature: magical teleportation through the steam tunnels.
As for those scraps of paper, I scanned those and put the images on my server.
I then threw the paper away.
Unfortunately, I managed to lock out my account on the server.
Hey! You’ve got some great skills. Would you please hack into my system and retrieve the scans?
I give you permission to hack into it, solving Objective 9 in your badge.
And, as long as you're traveling around, be sure to solve any other challenges you happen across.