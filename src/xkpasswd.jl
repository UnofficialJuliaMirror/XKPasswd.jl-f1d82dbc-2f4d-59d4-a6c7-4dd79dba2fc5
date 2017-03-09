module xkpasswd

datapath = joinpath(@__DIR__, "..", "data")
default_wordlist = joinpath(datapath, "google-10000-english",
                            "google-10000-english-usa-no-swears.txt")

pwentropy(n, total, digit) = n*log2(total) + (digit ? log2(10) : 0)

function generate(n::Integer; npws::Integer=1, capitalize::Bool=false,
                  wordlist::AbstractString=default_wordlist,
                  delimstr::AbstractString=" ", append_digit::Bool=true)
    @assert n > 0 "Must use at least 1 random word"
    @assert npws > 0 "Must generate at least 1 password"
    open(wordlist) do f
        lines = readlines(f, chomp=true)
        println(STDERR, "Estimated entropy: ~$(pwentropy(n,length(lines),append_digit) |> round |> Int) bits.")
        [(
            words = rand(lines, n);
            cased_words = capitalize ?  map(ucfirst, words) : words;
            string(join(cased_words, delimstr), 
                   append_digit ? "$(delimstr)$(rand(0:9))" : "")
         ) for k in 1:npws]
    end
end

end # module
