class Assembler
  attr_reader :filename, :assembly_code

  def initialize(filename)
    @filename = filename
    @assembly_code = File.readlines(filename)
  end

  def assemble
    # clean up code for processing
    cleaned = assembly_code.map do |line|
      line.strip! # remove all whitespace from start and end
      (line[0] == '/' || line.empty?) ? nil : line # remove comment lines and blank lines
    end.reject(&:nil?)
    
    assembled = cleaned.map do |instruction|
      instruction[0] == '@' ? translate_a(instruction) : translate_c(instruction)
    end.join("\n")

    File.write(filename.gsub('.asm','.hack'), assembled)
  end

  def translate_a(instruction)
    value = instruction[1..-1]
    # TODO: convert symbols to numerical address
    "%016b" % value
  end

  def translate_c(instruction)
    translated = "111"

    # parse instruction into dest, cmp and jmp
    dest, cmp, jmp = nil
    if instruction.include?('=')
      tmp = instruction.split('=')
      dest = tmp[0].strip
      cmp = tmp[1].split(';')[0].strip
    end
    tmp = instruction.split(';')
    cmp ||= tmp[0].strip
    jmp = tmp[1].strip if tmp[1]

    t_cmp = cmp_map(cmp)
    t_dest = dest_map(dest)
    t_jmp = jmp_map(jmp)

    translated + cmp_map(cmp) + dest_map(dest) + jmp_map(jmp)
  end
  
  def dest_map(dest)
    dest = dest.chars.sort.join if dest
    {
      nil => "000",
      "M" => "001",
      "D" => "010",
      "DM" => "011",
      "A" => "100",
      "AM" => "101",
      "AD" => "110",
      "ADM" => "111"
    }[dest]
  end
  
  def cmp_map(cmp)
    cmp = cmp.include?('-') ? cmp : cmp.chars.sort.join
    {
      "0" => "0101010",
      "1" => "0111111",
      "-1" => "0111010",
      "D" => "0001100",
      "A" => "0110000",
      "M" => "1110000",
      "!D" => "0001101",
      "!A" => "0110001",
      "!M" => "1110001",
      "-D" => "0001111",
      "-A" => "0110011",
      "-M" => "1110011",
      "+1D" => "0011111",
      "+1A" => "0110111",
      "+1M" => "1110111",
      "D-1" => "0001110",
      "A-1" => "0110010",
      "M-1" => "1110010",
      "+AD" => "0000010",
      "+DM" => "1000010",
      "D-A" => "0010011",
      "D-M" => "1010011",
      "A-D" => "0000111",
      "M-D" => "1000111",
      "&AD" => "0000000",
      "&DM" => "1000000",
      "AD|" => "0010101",
      "DM|" => "1010101"
    }[cmp]
  end

  def jmp_map(jmp)
    {
      nil => "000",
      "JGT" => "001",
      "JEQ" => "010",
      "JGE" => "011",
      "JLT" => "100",
      "JNE" => "101",
      "JLE" => "110",
      "JMP" => "111",
    }[jmp]
  end
end

filename = ARGV[0]
a = Assembler.new(filename)
a.assemble
