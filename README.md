# Organizer of Photographs

This repository is not really meant for public use. This program is
really only written for me. (If you find it useful, you're welcome to
it; do understand it moves files around, which means it may delete
them, and you'll lose precious memories, and I won't accept any blame
for it. Caveat cloner.)

Rather, I wanted to document the steps I took to arrive at this
program. We've been doing research on, and reading, papers on software
development methods and tools, and I thought it'd be interesting to
have a case study that I have intimate knowledge of to for future
reference.

Plus, it's a way to stash some code I may run again in a few years.

## Task

What does this program do? I take photographs with my phone, and back
them up automatically with (for now) Dropbox. They go into a "Camera 
Uploads" folder. Where they just sit … for years.

I could probably use some photo utility to auto-organize them, but I
don't. I store my photographs in carefully hand-curated
sub-directories. That takes a lot of time. So I don't get around to
it. It'd be a lot quicker to just use a photo utility. But I don't.

This program goes through a named folder (I didn't hard-code "Camera
Uploads" not because I'm a really careful programmer, but because at
some point I moved everything out of "Camera Uploads" to an _older_
dump of such files) and computes the date on the file. It does this
through the stupid expedient of ignoring file metadata (which anyway
are not available for all file formats) and instead just looking at
the filename. It then (rightly, in my case) assumes that temporal
locality must mean spatial locality, so it groups pictures that
weren't taken very long apart into clusters. I then get to process
each cluster at my leisure.

That's all. There's no machine learning, nothing. Just dumb code that
a first-year college student could write. Which is the point of making
this a case-study.

## How to Run

Coming soon.
