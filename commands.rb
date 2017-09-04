require "prime"

def vec1 a, &f
    if a.instance_of? Array
        a.map {|x| f[x]}
    else
        f[a]
    end
end
def vec2 a, b, &f
    if a.instance_of? Array and b.instance_of? Array
        (0...[a.length, b.length].max).map {|i| f[a[i % a.length], b[i % b.length]]}
    elsif a.instance_of? Array and not b.instance_of? Array
        a.map {|x| f[x, b]}
    elsif not a.instance_of? Array and b.instance_of? Array
        b.map {|y| f[a, y]}
    else
        f[a, b]
    end
end

def truthy e
    return (not e.empty?) if e.instance_of? Array
    return (not e.empty?) if e.instance_of? String
    return e != 0 if e.kind_of? Numeric
    e
end
def factorial n
    (1..n).reduce &:*
end
def revfact n
    n = n.to_f
    i = 1
    while n > 1
        i += 1
        n /= i
    end
    n == 1 ? i : 0
end
def fib n
    a = 0
    b = 1
    c = 1
    (n - 1).times do
        c = a + b
        a = b
        b = c
    end
    n == 0 ? 0 : c
end

PHI = (1 + Math::sqrt(5)) / 2

COMMANDS = {
    # String constants
    "H" => [0, proc{"Hello, World!"}],
    "Å" => [0, proc{"ABCDEFGHIJKLMNOPQRSTUVWXYZ"}],
    "Ƥ" => [0, proc{"BCDFGHJKLMNPQRSTVWXYZ"}],
    "Ý" => [0, proc{"AEIOU"}],
    "Ʊ" => [0, proc{"AEIOUY"}],
    "Ç" => [0, proc{CODEPAGE}],

    # Numerical constants
    "T" => [0, proc{10}],
    "Þ" => [0, proc{100}],
    "π" => [0, proc{Math::PI}],
    "φ" => [0, proc{PHI}],
    "e" => [0, proc{Math::E}],

    # Other constants
    "A" => [0, proc{|i| i.arguments.last}],
    "U" => [0, proc{[]}],
    "ø" => [0, proc{nil}],

    # Arithmetic
    "_" => [1, proc{|i, a| vec1 a, &:-@}],
    "D" => [1, proc{|i, a| vec1(a) {|x| x * 2}}],
    "ħ" => [1, proc{|i, a| vec1(a) {|x| x / 2}}],
    "Ŵ" => [1, proc{|i, a| vec1(a) {|x| x / 2.0}}],
    "Q" => [1, proc{|i, a| vec1(a) {|x| x * x}}],
    "₊" => [1, proc{|i, a| vec1(a) {|x| x + 1}}],
    "₋" => [1, proc{|i, a| vec1(a) {|x| x - 1}}],
    "⌊" => [1, proc{|i, a| vec1(a) {|x| x.instance_of? String ? x.downcase : x.floor}}],
    "⌈" => [1, proc{|i, a| vec1(a) {|x| x.instance_of? String ? x.upcase : x.ceil}}],
    "!" => [1, proc{|i, a| vec1(a) {|x| factorial x}}],
    "ƒ" => [1, proc{|i, a| vec1(a) {|x| revfact x}}],
    "F" => [1, proc{|i, a| vec1(a) {|x| fib x}}],
    "√" => [1, proc{|i, a| vec1(a) {|x| Math::sqrt x}}],
    "Ƃ" => [1, proc{|i, a| vec1(a) {|x| 1.0 / x}}],
    "a" => [1, proc{|i, a| vec1(a) {|x| x.abs}}],
    "m" => [1, proc{|i, a| a.reduce(&:+) / a.length.to_f}],
    "Ƣ" => [1, proc{|i, a| a.max}],
    "ƣ" => [1, proc{|i, a| a.min}],
    "Σ" => [1, proc{|i, a| a.reduce &:+}],
    "Π" => [1, proc{|i, a| a.reduce &:*}],
    "ś" => [1, proc{|i, a| Math::sin a}],
    "ð" => [1, proc{|i, a| Math::cos a}],
    "ĳ" => [1, proc{|i, a| Math::tan a}],

    "." => [3, proc{|i, a, b| vec2(a, b) {|x, y| (x.to_s + "." + y.to_s.reverse).to_f}}],
    "+" => [3, proc{|i, a, b| vec2 a, b, &:+}],
    "-" => [3, proc{|i, a, b| vec2 a, b, &:-}],
    "*" => [3, proc{|i, a, b| vec2 a, b, &:*}],
    "/" => [3, proc{|i, a, b| vec2(a, b) {|x, y| x / y.to_f}}],
    "÷" => [3, proc{|i, a, b| vec2 a, b, &:/}],
    "%" => [3, proc{|i, a, b| vec2 a, b, &:%}],
    "ⁿ" => [3, proc{|i, a, b| vec2 a, b, &:**}],
    "Ø" => [3, proc{|i, a, b| vec2(a, b) {|x, y| x ** (1.0 / y)}}],
    "Ğ" => [3, proc{|i, a, b| vec2(a, b) {|x, y| x.gcd y}}],
    "ğ" => [3, proc{|i, a, b| vec2(a, b) {|x, y| x.lcm y}}],

    # Logic
    "p" => [1, proc{|i, a| vec1(a) {|x| Prime.prime?(x) ? -1 : 0}}],
    "¬" => [1, proc{|i, a| vec1 a, &:~}],
    "=" => [3, proc{|i, a, b| a == b ? -1 : 0}],
    "≠" => [3, proc{|i, a, b| a != b ? -1 : 0}],
    "<" => [3, proc{|i, a, b| a < b ? -1 : 0}],
    ">" => [3, proc{|i, a, b| a > b ? -1 : 0}],
    "≤" => [3, proc{|i, a, b| a <= b ? -1 : 0}],
    "≥" => [3, proc{|i, a, b| a >= b ? -1 : 0}],
    "∧" => [3, proc{|i, a, b| vec2 a, b, &:&}],
    "⊼" => [3, proc{|i, a, b| vec2(a, b) {|x, y| ~(x & y)}}],
    "∨" => [3, proc{|i, a, b| vec2 a, b, &:|}],
    "⊽" => [3, proc{|i, a, b| vec2(a, b) {|x, y| ~(x | y)}}],
    "⊻" => [3, proc{|i, a, b| vec2 a, b, &:^}],
    "«" => [3, proc{|i, a, b| vec2 a, b, &:<<}],
    "»" => [3, proc{|i, a, b| vec2 a, b, &:>>}],

    # Type conversion
    "i" => [1, proc{|i, a| vec1(a) {|x| x.to_i}}],
    "f" => [1, proc{|i, a| vec1(a) {|x| x.to_f}}],
    "s" => [1, proc{|i, a| a.to_s}],
    "$" => [1, proc{|i, a| vec1(a) {|x| encode(x).each_char.map(&:ord).reduce {|x, y| (x << 8) | y}}}],

    # Array manipulation
    ":" => [1, proc{|i, a| [a]}],
    ";" => [3, proc{|i, a, b| [a, b]}],
    "₀" => [1, proc{|i, a| a[0]}],
    "₁" => [1, proc{|i, a| a[1]}],
    "₂" => [1, proc{|i, a| a[2]}],
    "₃" => [1, proc{|i, a| a[3]}],
    "₄" => [1, proc{|i, a| a[4]}],
    "₅" => [1, proc{|i, a| a[5]}],
    "₆" => [1, proc{|i, a| a[6]}],
    "₇" => [1, proc{|i, a| a[-3]}],
    "₈" => [1, proc{|i, a| a[-2]}],
    "₉" => [1, proc{|i, a| a[-1]}],
    "ᵢ" => [3, proc{|i, a, b| a[b]}],
    "ⱼ" => [7, proc{|i, a, b, c| a[b] = c}],
    "R" => [3, proc{|i, a, b| vec2(a, b) {|x, y| (x..y).to_a}}],
    "r" => [3, proc{|i, a, b| vec2(a, b) {|x, y| (x...y).to_a}}],
    "Ř" => [1, proc{|i, a| vec1(a) {|x| (1..x).to_a}}],
    "ř" => [1, proc{|i, a| vec1(a) {|x| (0...x).to_a}}],
    "M" => [1, proc{|i, a, b| a.map {|x| i.arguments.push [x]; e = i.eval b; i.arguments.pop; e}}],
    "S" => [1, proc{|i, a, b| a.select {|x| i.arguments.push [x]; e = truthy i.eval b; i.arguments.pop; e}}],
    "C" => [1, proc{|i, a, b| a.reduce {|x, y| i.arguments.push [x, y]; e = i.eval b; i.arguments.pop; e}}],
    "#" => [3, proc{|i, a, b| a + b}],
    "@" => [3, proc{|i, a, b| a * b}],
    "t" => [3, proc{|i, a, b| a.take b}],
    "d" => [3, proc{|i, a, b| a.drop b}],
    "z" => [3, proc{|i, a, b| a.zip b}],
    "ŋ" => [1, proc{|i, a| a.reverse}],
    "J" => [1, proc{|i, a| a.join}],
    "j" => [3, proc{|i, a, b| a.join b}],

    # String manipulation
    "ƥ" => [7, proc{|i, a, b, c| a.gsub b, c}],
    "ź" => [7, proc{|i, a, b, c| a.gsub Regexp.new(b), c}],
    "|" => [1, proc{|i, a| a.chars}],
    "¦" => [3, proc{|i, a, b| a.split b}],

    # Control flow
    "I" => [1, proc{|i, a, b| i.eval b if truthy a}],
    "E" => [1, proc{|i, a, b, c| if truthy a then i.eval b else i.eval c end}],
    "W" => [0, proc{|i, a, b| i.eval b while truthy i.eval a}],
    "L" => [3, proc{|i, a, b| i.run b, a}],
    "‹" => [1, proc{|i, a| i.run a, i.lines.last - 1}],
    "₡" => [1, proc{|i, a| i.run a, i.lines.last}],
    "›" => [1, proc{|i, a| i.run a, i.lines.last + 1}],

    # Registers
    "Ͱ" => [1, proc{|i, a| i.regs[0xF8] = a}],
    "Ͳ" => [1, proc{|i, a| i.regs[0xF9] = a}],
    "Ͷ" => [1, proc{|i, a| i.regs[0xFA] = a}],
    "ͱ" => [0, proc{|i| i.regs[0xF8]}],
    "ͳ" => [0, proc{|i| i.regs[0xF9]}],
    "ͷ" => [0, proc{|i| i.regs[0xFA]}],
    "↦" => [3, proc{|i, a, b| i.regs[a] = b}],
    "↤" => [1, proc{|i, a| i.regs[a]}],

    # Input/Output
    "Ꝇ" => [0, proc{STDIN.readline.chomp}],
    "ꝇ" => [1, proc{|i, a| puts a}],
}
