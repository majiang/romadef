import std.file, std.path, std.stdio;
import std.algorithm, std.array, std.range, std.string;
import std.conv;

void main(string[] args)
{
    foreach (arg; args[1..$])
    {
        auto input = arg.readText.
                replace("\\", "").
                replace("\r\n", "").
                replace(" ", "").
                split(",").
                map!(_=> _.to!ubyte(0x10)).
                array[0..$-2];
        with (File(arg.setExtension("txt"), "w"))
        {
            foreach (rd; input.splitter(0).map!(_=>_.split('=')))
            {
                rd.writeln;
                auto alphabets = cast(string)rd[0].dup;
                auto kanas = rd[1].fromCP932;
                writefln!"%s\t%s"(alphabets, kanas);
            }
        }
    }
}

string fromCP932(in ubyte[] arr)
{
    auto t = arr ~ 0;
    import std.windows.charset;
    return (cast(immutable(char)*)(t.ptr)).fromMBSz(932);
}
