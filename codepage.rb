t = File.read("./codepage.txt").lines.map do |l|
    l = l.chomp.gsub " ", "\0"
    l + "\0" * (16 - l.length)
end
t[2][0] = " "
t[15][15] = "\n"
CODEPAGE = t.join

def decode s
    s.each_char.map {|c| CODEPAGE[c.force_encoding("ASCII-8BIT").ord]}.join
end
def encode s
    s.each_char.map {|c| CODEPAGE.index(c).chr}.join
end
