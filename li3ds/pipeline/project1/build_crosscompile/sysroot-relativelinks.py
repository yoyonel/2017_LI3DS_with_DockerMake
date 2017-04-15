#!/usr/bin/env python
import sys
import os

# Take a sysroot directory and turn all the abolute symlinks and turn them into
# relative ones such that the sysroot is usable within another system.

if len(sys.argv) != 2:
    print("Usage is " + sys.argv[0] + "<directory>")
    sys.exit(1)

topdir = sys.argv[1]
topdir = os.path.abspath(topdir)
prepath_topdir = topdir.split('/'+sys.argv[1])[0]

def handlelink_(filep, subdir):
    link = os.readlink(filep)
    if link[0] != "/":
        return
    if link.startswith(topdir):
        return
    #print("Replacing %s with %s for %s" % (link, topdir+link, filep))
    print("Replacing %s with %s for %s" % (link, os.path.relpath(topdir+link, subdir), filep))
    os.unlink(filep)
    os.symlink(os.path.relpath(topdir+link, subdir), filep)

def handlelink(filep, subdir):
    link = os.readlink(filep)
    try:
        postpath_link = link.split("/"+sys.argv[1]+"/")[1]
        print("link: %s\npostpath_link: %s" % (link, postpath_link))
        print("")

        os.unlink(filep)
        os.symlink(os.path.abspath(prepath_topdir+'/catkin_ws/'+postpath_link), filep)
    except:
        pass


print("topdir: %s" % topdir)
print("prepath_topdir: " + prepath_topdir)

for subdir, dirs, files in os.walk(topdir):
    for f in files:
        filep = os.path.join(subdir, f)
        if os.path.islink(filep):
            print("Considering %s" % filep)
            handlelink(filep, subdir)
