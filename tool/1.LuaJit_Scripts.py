#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
NAME
    PackageScripts --

SYNOPSIS
    PackageScripts [-h]

    -h show help
    -p project root dir
    -b 32 or 64, luajit bytecode mode
"""

import os
import sys
import getopt
import shutil
import re
import platform
import subprocess

engineRoot = os.environ.get('QUICK_V3_ROOT')
scriptRoot = engineRoot + "quick/bin/"
jitPath = ""
new_env = os.environ.copy()

def joinDir(root, *dirs):
    for item in dirs:
        root = os.path.join(root, item)
    return root

def initJitPath(mode):
    global jitPath
    global new_env
    sysstr = platform.system()
    if(sysstr =="Windows"):
        if "32" == mode:
            jitPath = joinDir(scriptRoot, "win32", "luajit.exe")
        else:
            jitPath = joinDir(scriptRoot, "win32", "64", "luajit.exe")
    elif(sysstr == "Linux"):
        print "Liunux Support is coming sooooon"
        sys.exit(-1)
    elif(sysstr == "Darwin"):
        jitPath = joinDir(scriptRoot, "mac", "luajit")
        if "64" == mode:
            jitPath = jitPath + "64"
    else:
        print "Unsupport OS!"
        sys.exit(-1)

    # important, to find luajit lua
    new_env['LUA_PATH'] = joinDir(scriptRoot, "?.lua")

def doFile(nDir, jDir):
    jitcmd = '%s -bg "%s" "%s"' %(jitPath, nDir, jDir)
    # do shell cmd
    cmd = subprocess.Popen(jitcmd, shell = True, stdout = subprocess.PIPE, env = new_env)
    cmd.wait()
    if os.path.exists(jDir) == False:
        print "Error: Fail to compile:%s" %(nDir)
        sys.exit(-1)

def copyDir(luaRoot, jitSrcPath, mode):
    for item in os.listdir(luaRoot):
        if "." == item[0]: # ignore hidden files
            continue

        nDir = joinDir(luaRoot, item)
        jDir = joinDir(jitSrcPath, item)
        if os.path.isfile(nDir):
            if nDir.endswith(".lua"): # only do lua file
                print "%s" %(nDir)
                doFile(nDir, jDir + mode)
            else:
                if not os.path.exists(jDir):
                    shutil.copyfile(nDir, jDir)
        else:
            if not os.path.exists(jDir):
                os.mkdir(jDir)
            copyDir(nDir, jDir, mode)

def packageScript(projectDir, mode):
    luaRoot = joinDir(projectDir, "src")
    if not os.path.exists(luaRoot):
        print "Error: %s is not exists" %(luaRoot)
        sys.exit(-2)

    srcBKPath = joinDir(projectDir, "src_bk")
    if os.path.exists(srcBKPath):
        shutil.rmtree(srcBKPath)
    #os.mkdir(srcBKPath)
    shutil.copytree(luaRoot, srcBKPath)

    jitSrcPath = joinDir(projectDir, "src_jit")
    if not os.path.exists(jitSrcPath):
        os.mkdir(jitSrcPath)

    print "====> init evn."
    initJitPath(mode)

    print "====> start."
    copyDir(luaRoot, jitSrcPath, mode)
    print "====> ended."

if __name__ == "__main__":
    # ===== parse args =====
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hp:b:")
    except getopt.GetoptError:
        # print help information and exit:
        print __doc__
        sys.exit(-2)

    # default value
    projectDir = "E:/Idea/base/"
    mode = "32"

    for o, a in opts:
        if o == "-h":
            # print help information and exit:
            print __doc__
            sys.exit(0)
        if o == "-p":
            projectDir = a
        if o == "-b":
            if "32" != a and "64" != a:
                print "Error: bytecode mode only support 32 or 64"
                sys.exit(-2)
            mode = a

    # check valid
    if 0 == len(projectDir):
        print "Error: -p must set"
        sys.exit(-2)
    if not os.path.exists(projectDir):
        print "Error: %s is not exists" %(projectDir)
        sys.exit(-2)

    # info printing
    print "== engineRoot: %s" %(engineRoot)
    packageScript(projectDir, mode)
