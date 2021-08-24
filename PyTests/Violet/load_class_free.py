# Song is : 'Tale as old as time' from 'Beauty and the beast'.

def sing():
    lyrics = 'Tale as old as time'

    class Princess:
        # This will produce the ever-elusive 'LOAD_CLASSDEREF' opcode.
        assert lyrics == 'Tale as old as time'
        lyrics = 'Tune as old as song.'

    assert lyrics == 'Tune as old as song.'
