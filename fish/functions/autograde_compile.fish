function autograde_compile
	bash -c "javac -cp lib/*:. $argv[1].java; java -cp lib/*:. $argv[1]; exit"
end
