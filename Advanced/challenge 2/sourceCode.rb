require 'etc'
# mv function
def mv source,destination
    File.rename source, destination
end

# whoami 
def whoami
puts Etc.getlogin 
end

# ls function
def ls 
   files= Dir.entries(File.dirname(__FILE__))
(0).step(files.size,1) do |x|
    if(files[x]!="." && files[x]!="..")
        if(File.directory?("#{files[x]}"))
            print "#{files[x]}/  "
        else
            print "#{files[x]}  "
        end
    end

end
puts ""
end

#  grep function
def grep (filename,regexp)
  File.foreach(filename) do |line|
      
     if line =~ /#{regexp}/
         puts line
     end
  end
  
end

# cp function
def cp input,output
f_in = File.open input, "r"
f_out = File.open output, "w"

f_in.each {|line| f_out << line}

f_in.close
f_out.close
end



# head function
def head (filename,linesNo)
    if(linesNo==0)
   return
  end
    allFile=Array.new
  File.foreach(filename) do |line|
     allFile.push(line)
  end
  availableLines=linesNo-1
  
      
  if allFile.size<linesNo
      availableLines=-1
  end
  
      allFile[0..availableLines].each do |line|
          puts line
      end
  
  
end


# tail function
def tail (filename,linesNo)
    if(linesNo==0)
   return
  end
    allFile=Array.new
  File.foreach(filename) do |line|
     allFile.push(line)
  end
  availableLines=allFile.size-linesNo
  
      
  if allFile.size<linesNo
      availableLines=0
  end
  
      allFile[availableLines..-1].each do |line|
          puts line
      end
  
  
end

# //////////////////////////////////////////////////////////////////////////
# starting the command prompt
print "waelPrompt>>"
userinput=gets.chomp 

while userinput.strip.size>0 do
    
    userinputArray=userinput.split(' ')
    if userinputArray.size>0 
        case userinputArray[0]
        when "ls"
            ls 
        when "grep"
            if(userinputArray.size<3)
                puts "wrong number of parameters"
            else
                grep(userinputArray[-1],userinputArray[1])
            end
        when "head"
            if(userinputArray.size<2)
                puts "wrong number of parameters"
            elsif(userinputArray.size==2)
            head(userinputArray[-1],10)
            elsif userinputArray.size==4 && userinputArray[1]=="-n" && userinputArray[2]  !~ /\D/
            head(userinputArray[-1],userinputArray[2].to_i)
            else 
            puts "error"
            end    
        
        when "tail"
            if(userinputArray.size<2)
                puts "wrong number of parameters"
            elsif(userinputArray.size==2)
            tail(userinputArray[-1],10)
            elsif userinputArray.size==4 && userinputArray[1]=="-n" && userinputArray[2]  !~ /\D/
            tail(userinputArray[-1],userinputArray[2].to_i)
            else 
            puts "error"
            end   
        when "cp"
            if(userinputArray.size<3)
                puts "wrong number of parameters"
            elsif(userinputArray.size==3)
            cp(userinputArray[1],userinputArray[2])
            else 
            puts "error"
            end   
        when "mv"
            if(userinputArray.size<3)
                puts "wrong number of parameters"
            elsif(userinputArray.size==3)
            cp(userinputArray[1],userinputArray[2])
            else 
            puts "error"
            end   
        when "whoami"
            whoami
             
            
        else
            puts "command not found"
        end
    else
        puts ""
    end
    print "waelPrompt>>"
    userinput=gets.chomp 
end

