=begin
======================================================
  
  Custom Note Files v1.1
  by Adiktuzmiko                   
  
  Date Created: 12/16/2014
  Date Last Updated: 07/08/2015
  Requires: N/A
  Difficulty: Easy
  
======================================================
 Overview
======================================================
 
 This script allows you to create text files from
 where you want to load the notetags for the database
 entries in your game.
 
 Allows you to make different files so that you can
 segregate the notes. 
 
======================================================
 Usage
====================================================== 

 Put this script into your scripts editor and modify
 the settings below
 
 Create your note files where you want them to be and
 just modify the FILES hash on the set-up part below.
 
 Start tagging your database objects with
 
 <note:key:index>
 <end_note_index>
 
 Where key determines which file to open and index
 is the index of the tag on the file.
 
 Example notetag text file:
 
 It is important to not put any spaces after the : part
 
 <note:key:1>
   notetags here
 <end_note_1>
 
 Let's say this note is in a file that is registered
 using the symbol :items, this is how the note in the database
 should look like:
 
 <note:items:1>
 <end_note_1>
 
 Note: index can be any string
======================================================
 Compatibility
======================================================

 Aliases RPG::BaseItem's note method
 
 Aliases DataManager's load_database method
 
 This would work for all database entries that uses the RPG::BaseItem
 and/or it's subclasses as it's parent class
 
 This would work for any script that uses notetags as long as they use
 the .note call instead of using @note directly from inside the
 RPG::BaseItem class
 
======================================================
 Terms and Conditions
======================================================

 View it here: http://lescripts.wordpress.com/terms-and-conditions/

======================================================
=end

module CUSTOM_NOTE
  
  #======================================================
  #Collection of paths and symbol used
  #for different note files
  
  #Format: FILES[symbol] = Path
  
  #The symbol you use here will also be the symbol that you will
  #use in your database notetags
  
  #Make sure you create the files before testing
  #======================================================
  FILES = {}
  FILES[:arts] = "System\\Arts.txt"
  
  #======================================================
  #  Do not edit below this line    
  #======================================================
  
  def self.load_notes
    return if @note != nil
    @note = {}
    FILES.each do |key,value|
      File.open(value,"rb") do |file|
        @note[key] = file.read
      end
    end
  end
  
  def self.note(key)
    return @note[key]
  end
  
end

#======================================================
#  Do not edit below this line    
#======================================================

module DataManager
  
  class << self;alias load_database_custom_notes load_database;end;
  def self.load_database
    load_database_custom_notes
    CUSTOM_NOTE.load_notes
  end
end

class RPG::BaseItem
  
  REGEX = /<note:(.*):(.*)>/
  
  alias note_adik_custom note
  def note
    if @note =~ REGEX
      return $1 if CUSTOM_NOTE.note($1.to_sym) =~ /<note:#{$2}>(.*)<end_note_#{$2}>/m
    else
      return @note
    end
  end
  
end
