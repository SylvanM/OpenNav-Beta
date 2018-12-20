//
//  Navigator.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/26/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

enum NavigationError: Error {
    case noSuchRoomInBuilding
    case layoutNotRoutable
}

class Navigator {
    
    func makePath(start: Int, end: Int, layout: [String], correction: [Int], numFloors: Int, dimensions: [Int]) throws -> [UIImage] {
        // Make the path, and place those blue dot things on the images of the floors. Return the new image array.
        
        struct Room{
            var rmAbove:Int;
            var rmBelow:Int;
            var rmRight:Int;
            var rmLeft:Int;
            var rmTop:Int;
            var rmBottom:Int;
            var rmCode:Int;
            var rmNumber:Int;
            var teacher:String;
            var row:Int;
            var col:Int;
            var floor:Int;
            init (){
                rmAbove=0;
                rmBelow=0;
                rmRight=0;
                rmLeft=0;
                rmTop=0
                rmBottom=0;
                rmCode = 2;
                rmNumber = 0;
                teacher="";
                row = 0;
                col = 0;
                floor = 0;
                
            }
            mutating func modify(nrmCode : Int, nNumber : Int, nTeacher : String, nrow : Int, ncol : Int, nfloor : Int){
                rmCode = nrmCode;
                rmNumber = nNumber;
                teacher = nTeacher;
                row = nrow;
                col = ncol;
                floor = nfloor;
            }
            mutating func setSurroundingRooms(above : Int, right : Int, below : Int, left : Int, top : Int, bottom : Int){
                rmAbove = above
                rmRight = right
                rmBelow = below
                rmLeft = left
                rmTop = top
                rmBottom = bottom
            }
            
            mutating func set(otherRoom : Room){
                self.rmAbove=otherRoom.rmAbove
                self.rmBelow=otherRoom.rmBelow
                self.rmRight=otherRoom.rmRight
                self.rmLeft=otherRoom.rmLeft
                self.rmTop=otherRoom.rmTop
                self.rmBottom=otherRoom.rmBottom
                self.rmCode = otherRoom.rmCode
                self.rmNumber = otherRoom.rmNumber
                self.teacher=otherRoom.teacher
                self.row = otherRoom.row
                self.col = otherRoom.col
                self.floor = otherRoom.floor
            }
        }
        
        
        
        //MARK:initialize 3d array
        var school:Array = [[[Room]]]()
        var count = 0;
        for index in 1...numFloors+1{
            var aRoom:Room = Room()
            var floorArray:Array = [[Room]]()
            floorArray = Array(repeating : Array(repeating : aRoom,count:dimensions[count]),count:dimensions[count+1])
            school.append(floorArray)
            count = count + 2
        }
        
        //MARK:Set Array values based on data
        for item in layout{
            var eachPart = item.components(separatedBy: " ")
            var floor : Int = 999;
            var row : Int = 999;
            var col : Int = 999;
            var code : Int = 999;
            var num : Int = 999;
            var tname : String = "";
            for index in 0...5{
                var part = eachPart[index]
                if (index==0){
                    floor = Int(part)!;
                }else if (index==1){
                    row = Int(part)!;
                }else if (index==2){
                    col = Int(part)!;
                }else if (index==3){
                    code = Int(part)!;
                }else if (index==4){
                    num = Int(part)!;
                }else if (index==5){
                    tname = part;
                }
                
            }
            
            school[floor][row][col].modify(nrmCode: code, nNumber: num, nTeacher: tname, nrow : row, ncol : col, nfloor : floor)
            
        }
        
        
        
        
        
        //MARK:Initialize Surrounding Rooms with respective Room code
        var tempRoom = 2
        var Rabove = 9,Rright = 9,Rleft = 9,Rbelow = 9,Rtop = 9, Rbottom = 9
        //why is swift so annoying and stupid
        for flr in 1...school.count-1{
            for row in 0...school[flr].count-1{
                for col in 0...school[flr][row].count-1{
                    tempRoom = 2
                    Rabove = 9
                    Rright = 9
                    Rleft = 9
                    Rbelow = 9
                    Rtop = 2
                    Rbottom = 2
                    if (school[flr][row][col].rmCode == 3){
                        
                        if ((school[flr][row][col].floor) != numFloors){
                            Rtop = 3
                            
                            
                        }
                        if ((school[flr][row][col].floor) != 1){
                            Rbottom = 3
                            
                        }
                    }
                    if ((row-1) == -1){
                        Rabove = tempRoom
                    }else{
                        Rabove = school[flr][row-1][col].rmCode
                    }
                    
                    if ((row+1) == school[flr].count){
                        Rbelow = tempRoom
                    }else{
                        Rbelow = school[flr][row+1][col].rmCode
                    }
                    
                    if ((col-1) == -1){
                        Rleft = tempRoom
                    }else{
                        Rleft = school[flr][row][col-1].rmCode
                    }
                    
                    if ((col+1) == school[flr][row].count){
                        Rright = tempRoom
                    }else{
                        Rright = school[flr][row][col+1].rmCode
                    }
                    
                    school[flr][row][col].setSurroundingRooms(above:Rabove,right:Rright,below:Rbelow,left:Rleft,top:Rtop,bottom:Rbottom)
                    
                }
            }
        }
        
        
        
        //MARK:Change corners/corrections
        
        for i in stride(from: 0, to: correction.count, by: 4){
            
            if (school[correction[i]][correction[i+1]][correction[i+2]].rmAbove == 0 || school[correction[i]][correction[i+1]][correction[i+2]].rmAbove == 3){
                if (correction[i+3] != 1){
                    school[correction[i]][correction[i+1]-1][correction[i+2]].rmBelow = 2
                    school[correction[i]][correction[i+1]][correction[i+2]].rmAbove = 2
                }
            }
            if (school[correction[i]][correction[i+1]][correction[i+2]].rmRight == 0 || school[correction[i]][correction[i+1]][correction[i+2]].rmRight == 3){
                if (correction[i+3] != 2){
                    school[correction[i]][correction[i+1]][correction[i+2]+1].rmLeft = 2
                    school[correction[i]][correction[i+1]][correction[i+2]].rmRight = 2
                }
            }
            if (school[correction[i]][correction[i+1]][correction[i+2]].rmBelow == 0 || school[correction[i]][correction[i+1]][correction[i+2]].rmBelow == 3){
                if (correction[i+3] != 3){
                    school[correction[i]][correction[i+1]+1][correction[i+2]].rmAbove = 2
                    school[correction[i]][correction[i+1]][correction[i+2]].rmBelow = 2
                }
            }
            if (school[correction[i]][correction[i+1]][correction[i+2]].rmLeft == 0 || school[correction[i]][correction[i+1]][correction[i+2]].rmLeft == 3){
                if (correction[i+3] != 4){
                    school[correction[i]][correction[i+1]][correction[i+2]-1].rmRight = 2
                    school[correction[i]][correction[i+1]][correction[i+2]].rmLeft = 2
                }
            }
        }
        
        
        
        
        
        
        struct node{
            var type:Int;
            var row:Int;
            var col:Int;
            var floor:Int;
            var colored:Bool;
            var parentRow:Int;
            var parentCol:Int;
            var parentFloor:Int;
            init(){
                type = 1;
                row = 0;
                col = 0;
                floor = 0;
                colored = false;
                parentRow = 0;
                parentCol = 0;
                parentFloor = 0;
            }
            mutating func setType(newtype:Int){
                self.type = newtype;
            }
            mutating func setLoc(nrow:Int, ncol:Int, nfloor:Int){
                self.row = nrow
                self.col = ncol
                self.floor = nfloor
            }
            mutating func setParent(parent: node){
                if (!self.colored){
                    self.parentRow = parent.row
                    self.parentCol = parent.col
                    self.parentFloor = parent.floor
                    //print(self)
                }
                
            }
            mutating func setColored(){
                self.colored = true
            }
            func getParent()->(Int,Int,Int){
                return (parentRow,parentCol,parentFloor)
            }
            
        }
        
        var allvisit:Array=[node]()
        //MARK:Begin breadth first search method
        //queue will store nodes to be evaluated first in first out queue structure array
        var queue:Array = [node]()
        var schoolNodes:Array = [[[node]]]()
        
        var aNode = node()
        var count1 = 0;
        for index in 1...numFloors+1{
            var floorNodes:Array = [[node]]()
            floorNodes = Array(repeating : Array(repeating : aNode,count:dimensions[count1]),count:dimensions[count1+1])
            schoolNodes.append(floorNodes)
            count1 = count1 + 2
        }
        
        
        
        //fix thirdfloornodes to show 0 for halls, 2 for target, and leave as 1 for everything else
        //add first room to list
        for flr in 1...school.count-1{
            for row in 0...school[flr].count-1{
                for col in 0...school[flr][row].count-1{
                    schoolNodes[flr][row][col].setLoc(nrow: row, ncol: col, nfloor: flr)
                    if (school[flr][row][col].rmCode == 0 || school[flr][row][col].rmCode == 3){
                        schoolNodes[flr][row][col].setType(newtype: 0);
                    }
                    if (school[flr][row][col].rmNumber == (start)){
                        queue.append(schoolNodes[flr][row][col])
                    }
                    if (school[flr][row][col].rmNumber == end){
                        schoolNodes[flr][row][col].setType(newtype: 2)
                    }
                }
            }
        }
        
        
        
        var found = false;
        
        while ((!queue.isEmpty) && (found == false)){
            
            //pop off node and set it equal to item
            //swift is being annoying and running when i dont want it to
            var item : node
            item = queue.remove(at:0)
            
            if (item.colored == false){
                
                schoolNodes[item.floor][item.row][item.col].setColored()
                
                if ((school[item.floor][item.row][item.col].rmAbove == 0 || school[item.floor][item.row][item.col].rmAbove == 1 || school[item.floor][item.row][item.col].rmAbove == 3) && !found){
                    if (school[item.floor][item.row][item.col].rmAbove == 0 || school[item.floor][item.row][item.col].rmAbove == 3){
                        schoolNodes[item.floor][item.row - 1][item.col].setParent(parent: item)
                        queue.append(schoolNodes[item.floor][item.row - 1][item.col])
                    }else if (schoolNodes[item.floor][item.row - 1][item.col].type == 2){
                        schoolNodes[item.floor][item.row - 1][item.col].setParent(parent: item)
                        found = true;
                    }
                }
                if ((school[item.floor][item.row][item.col].rmRight == 0 || school[item.floor][item.row][item.col].rmRight == 1 || school[item.floor][item.row][item.col].rmRight == 3) && !found){
                    if (school[item.floor][item.row][item.col].rmRight == 0 || school[item.floor][item.row][item.col].rmRight == 3){
                        schoolNodes[item.floor][item.row][item.col + 1].setParent(parent: item)
                        queue.append(schoolNodes[item.floor][item.row][item.col + 1])
                    }else if (schoolNodes[item.floor][item.row][item.col + 1].type == 2){
                        schoolNodes[item.floor][item.row][item.col + 1].setParent(parent: item)
                        found = true;
                    }
                    
                }
                
                if ((school[item.floor][item.row][item.col].rmBelow == 0 || school[item.floor][item.row][item.col].rmBelow == 1 || school[item.floor][item.row][item.col].rmBelow == 3) && !found){
                    if (school[item.floor][item.row][item.col].rmBelow == 0 || school[item.floor][item.row][item.col].rmBelow == 3){
                        schoolNodes[item.floor][item.row + 1][item.col].setParent(parent: item)
                        queue.append(schoolNodes[item.floor][item.row + 1][item.col])
                    }else if (schoolNodes[item.floor][item.row + 1][item.col].type == 2){
                        schoolNodes[item.floor][item.row + 1][item.col].setParent(parent: item)
                        found = true;
                    }
                    
                    
                }
                if ((school[item.floor][item.row][item.col].rmLeft == 0 || school[item.floor][item.row][item.col].rmLeft == 1 || school[item.floor][item.row][item.col].rmLeft == 3) && !found){
                    if (school[item.floor][item.row][item.col].rmLeft == 0 || school[item.floor][item.row][item.col].rmLeft == 3 ){
                        schoolNodes[item.floor][item.row][item.col - 1].setParent(parent: item)
                        queue.append(schoolNodes[item.floor][item.row][item.col - 1])
                    }else if (schoolNodes[item.floor][item.row][item.col - 1].type == 2){
                        schoolNodes[item.floor][item.row][item.col - 1].setParent(parent: item)
                        found = true;
                    }
                }
                
                if (school[item.floor][item.row][item.col].rmTop == 3  && !found){
                    if (school[item.floor][item.row][item.col].rmTop == 3 ){
                        schoolNodes[item.floor + 1][item.row][item.col].setParent(parent: item)
                        queue.append(schoolNodes[item.floor + 1][item.row][item.col])
                        
                    }
                }
                if (school[item.floor][item.row][item.col].rmBottom == 3  && !found){
                    if (school[item.floor][item.row][item.col].rmBottom == 3 ){
                        schoolNodes[item.floor - 1][item.row][item.col].setParent(parent: item)
                        queue.append(schoolNodes[item.floor - 1][item.row][item.col])
                    }
                }
                
                
            }
            
            
        }
        
        
        
        //print out cells to go to
        var OC = 0
        var OR = 0
        var OF = 0
        var NC = 0
        var NR = 0
        var NF = 0
        
        for flr in 1...school.count-1{
            for row in 0...school[flr].count-1{
                for col in 0...school[flr][row].count-1{
                    if (school[flr][row][col].rmNumber == end){
                        NR = row
                        NC = col
                        NF = flr
                    }
                    
                    if (school[flr][row][col].rmNumber == start){
                        OR = row
                        OC = col
                        OF = flr
                    }
                }
            }
        }
        
        print("From ", start, " to ", end)
        var allVisitedRooms:Array<Array<String>> = []
       
            var AHA = schoolNodes[NF][NR][NC]
           
            
            while(!(AHA.row == OR && AHA.col == OC && AHA.floor == OF)){
                
                var toArray:Array<String> = []
                
               
                toArray.append(String(AHA.floor))
                toArray.append(String(AHA.row))
                toArray.append(String(AHA.col))
                
                allVisitedRooms.append(toArray)
                print(toArray)
                AHA = schoolNodes[AHA.parentFloor][AHA.parentRow][AHA.parentCol]
                
            }
        
        
        
        
        
        
        
        
        
        
    }
    
}
