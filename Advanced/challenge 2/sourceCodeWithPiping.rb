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
def grep (filename,regexp,piping)
    foundLines = Array.new
  File.foreach(filename) do |line|
      
     if line =~ /#{regexp}/
         foundLines<< line
     end
  end
  
  if piping
    f_out = File.open "temp.txt", "w"
    foundLines.each {|line| f_out << line}
    f_out.close
    
  else
      foundLines.each do |line|
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
def head (filename,linesNo,piping)
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
  
  if piping
    f_out = File.open "temp.txt", "w"
    allFile[0..availableLines].each {|line| f_out << line}
    f_out.close
    
  else
      allFile[0..availableLines].each do |line|
          puts line
      end
  end
  
  
end


# tail function
def tail (filename,linesNo,piping)
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
  if piping
    f_out = File.open "temp.txt", "w"
    allFile[availableLines..-1].each {|line| f_out << line}
    f_out.close
    
  else
      allFile[availableLines..-1].each do |line|
          puts line
      end
  end
      
end


def handleCommands command,piping=false,first=false # command is for passing command, piping true of false , first to take the file name from user the first command and use my default "temp.txt" file for the others
    userinputArray=command.split(' ')
    if userinputArray.size>0 
        case userinputArray[0]
        when "ls"
            ls 
        when "grep"
            if((userinputArray.size<3 && !piping && !first) || (userinputArray.size<3 && piping && first))# because if it's not piping or it is piping but this is the first command then it should at least 3 inputs 
                puts "wrong number of parameters"
            else
                if(!piping || (piping && first))
                grep(userinputArray[-1],userinputArray[1],piping)
                else
                    grep("temp.txt",userinputArray[1],piping) # if piping and not the first command always read from my default txt file "temp.txt"
                end
            end
        when "head"
            if(userinputArray.size<2 && !piping && !first)
                puts "wrong number of parameters"
            elsif (userinputArray.size==1 && piping && !first)
                head("temp.txt",10,piping)
            elsif((userinputArray.size==2 && !piping && !first) || (userinputArray.size==2 && piping && first))
            head(userinputArray[-1],10,piping)
            elsif(userinputArray.size==3 && userinputArray[1]=="-n" && userinputArray[2]  !~ /\D/ && piping && !first)
            head("temp.txt",userinputArray[2].to_i,piping)
            elsif userinputArray.size==4 && userinputArray[1]=="-n" && userinputArray[2]  !~ /\D/
            head(userinputArray[-1],userinputArray[2].to_i,piping)
            else 
            puts "error1"
            end    
        
        when "tail"
            if(userinputArray.size<2 && !piping && !first)
                puts "wrong number of parameters"
            elsif (userinputArray.size==1 && piping && !first)
                tail("temp.txt",10,piping)
            elsif((userinputArray.size==2 && !piping && !first) || (userinputArray.size==2 && piping && first))
            tail(userinputArray[-1],10,piping)
            elsif(userinputArray.size==3 && userinputArray[1]=="-n" && userinputArray[2]  !~ /\D/ && piping && !first)
            tail("temp.txt",userinputArray[2].to_i,piping)
            elsif userinputArray.size==4 && userinputArray[1]=="-n" && userinputArray[2]  !~ /\D/
            tail(userinputArray[-1],userinputArray[2].to_i,piping)
            else 
            puts "error2"
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
end
# //////////////////////////////////////////////////////////////////////////
# starting the command prompt
print "waelPrompt>>"
userinput=gets.chomp 

while userinput.strip.size>0 do
    if userinput.include? "|"
        # do piping
        pipingCommand=userinput.split('|')
        handleCommands pipingCommand[0],true,true # first time take the file name from user in the first command
        
        (1).step(pipingCommand.size-1) do |i|
            handleCommands pipingCommand[i],true # for the rest of the commands put the output to my default file
        end
        f_in = File.open "temp.txt", "r"
        f_in.each {|line| puts line}
        f_in.close
    
    #File.delete "temp.txt"
        
        
    else
    handleCommands userinput,false
    end
    print "waelPrompt>>"
    userinput=gets.chomp 
end

