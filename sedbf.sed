#!/bin/sed -Ef
# Brainfuck interpreter in sed
# Input (single line): <code>!<input bytes>
# Output: <whatever bytes input code produces, separated by spaces>
# Bytes are written as decimal numbers from 000 to 255. 
# Leading 0s are not optional.

#
# State of the interpreter is stored as a string:
#   <program>%<current instruction><the rest of program>!<input>#<memory>:<current cell><memory>;<output>
# (!<input> is optional)
#
# : acts as a memory pointer, with memory cell right to it being used in all operations.
# % acts as an instruction pointer, with instruction right to it being executed next
#

# Clean up unnecessary characters
s/[^][+,.<>!0-9-]//g

# Prepare the state of our virtual machine, by creating instruction pointer and a single empty memory cell
s/.*/% &#:000;/

# Main loop
# 'ba' instruction returns to this label
:a

# Move instruction pointer by one instruction
s/%(.)/\1%/


# Pattern matching:
# /%X/{ ... } is executed whenever instruction pointer is next to instruction X

# Increment
/%\+/{
    # Simulate 8bit wrapping
    /:255/{
        s/:255/:000/
        ba
    }

    # Put _ before the digit we want to increment
    # If number ends with 0-8, mark the last digit
    s/:..[^9]/&_/

    # If number ends in 99, mark the first digit
    # and replace 9s with 0s
    s/(:.)99/\1_00/

    # If number ends in 9 we replace last 9 with 0 and
    # mark the middle digit
    s/(:..)9/\1_0/

    # Increment the marked digit

    # There is a much shorter method:
    #    h
    #    y/876543210/987654321/
    #    G
    #    s/.*(.)_.*\n(.*)._/\2\1/
    # But it is also much, much slower

    s/8_/9/
    s/7_/8/
    s/6_/7/
    s/5_/6/
    s/4_/5/
    s/3_/4/
    s/2_/3/
    s/1_/2/
    s/0_/1/
}

# Decrement, pretty much the same idea is increment
/%-/{
    /:000/{
        s/:000/:255/
        ba
    }

    s/:..[^0]/&_/
    s/(:.)00/\1_99/
    s/(:..)0/\1_9/

    s/1_/0/
    s/2_/1/
    s/3_/2/
    s/4_/3/
    s/5_/4/
    s/6_/5/
    s/7_/6/
    s/8_/7/
    s/9_/8/
}

# Move the cell pointer by one cell right, creating new memory if necessary
/%>/{
    s/:(...);/:\1000;/
    s/:(...)/\1:/
}

# Move cell pointer left 
/%</{
    s/#:/#000:/
    s/(...):/:\1/
}

# Read from input buffer
/%,/{
    # Nothing to read, reset memory cell
    /![0-9]{3}/!s/:.../:000/

    # Copies the byte into current memory cell
    s/!([0-9]{3})(.*:).../!\2\1/

}

# Write to the output buffer
# Appends value of current cell to the end of string
# adds a space for readability
/%\./s/.*:(...).*/&\1 /
    
# Enter loop
# If current memory cell is non-empty, just continue
# If it is, find the matching ] and move pointer right before it
/%\[/{
    # At least one digit is non-zero
    /:000/!ba

    # Otherwise, ignore code up until the end of the loop

    # String of "a"s at the end of memory are used as a unary counter,
    # to count how deep inside nested brackets 

    # A loop is used to find matching bracket
    :b

    # Decrement the counter for each closing bracket
    /%]/s/a//

    # Increment for each open
    /%\[/s/$/a/

    # Move pointer to the right
    /a$/s/%(.)/\1%/

    # Repeat until nothing changes, i.e. counter becomes zero
    tb

    # A jump is necessary here, because we haven't matched any text 
    # since previous jump to make 'ta' jump back to start
    ba
}

# Continue loop
# Once we hit the closing bracket, we need to jump back to the start of the loop
/%]/{
    # Again using an unary counter

    :c
    # Move left until matching bracket is found
    /%\[/s/a//
    /%]/s/$/a/
    /a$/s/(.)%/%\1/
    tc

    # Move the instruction pointer by one instruction to the left
    s/(.)%/%\1/
}

ta

# If no instruction is found, we can stop execution
# Everything except the output is deleted
s/.*;//
