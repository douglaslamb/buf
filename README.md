# Buf

Buf is a dead simple short-term memory aid. The user enters a short reminder and specifies how many hours until the reminder expires. The user can print the list of unexpired reminders. When a reminder expires it is moved to the archive file.

## Install

Note: `gem install buf` fails because of a new Ruby version, I think. This repo is preserved for historical purposes.

## Configuration

Buf creates ~/.bufrc when it is first run, unless ~/.bufrc already exists. Buf also creates buffile.txt and buffile.txt.archive when Buf is first run. Buffile.txt and buffile.txt.archive are located in ~ by default, but their locations can be changed in ~/.bufrc.

## Usage

Append note to buffile with the expiration time

```
buf wr NOTE TIME
```

Print unexpired notes

```
buf echo
```

Example:

```
buf wr "Feed the cat" 3
buf echo
=> 1. Feed the cat 0:2:59
```

"Feed the cat" will be printed upon running `buf echo` for the next three hours. In three hours "Feed the cat" will be moved from buffile.txt to buffile.txt.archive.
