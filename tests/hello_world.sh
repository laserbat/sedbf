#!/bin/bash
# Examples from
# https://codegolf.stackexchange.com/questions/55422/hello-world/68494#68494

# Takes relatively long time to run
# Produces this output:
#
# Hello, World!
# hello, world!
# Hello World!
# hello world!

cd "$(dirname "$0")"

bf(){
    ../sedbf.sed | ../tools/bytes_to_ascii.py
}

echo "--<-<<+[+[<+>--->->->-<<<]>]<<--.<++++++.<<-..<<.<+.>>.>>.<<<.+++.>>.>>-.<<<+." | bf 
echo
echo "-<++[[<+>->->+++>+<<<]->]<<.---.<..<<.<<<---.<<<<-.>>-.>>>>>.+++.>>.>-.<<." | bf
echo 
echo "+[++[<+++>->+++<]>+++++++]<<<--.<.<--..<<---.<+++.<+.>>.>+.>.>-.<<<<+." | bf
echo
echo "+++[>--[>]----[----<]>---]>>.---.->..>++>-----.<<<<--.+>>>>>-[.<]" | bf
echo
