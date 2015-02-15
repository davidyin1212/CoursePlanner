# -*- coding: utf-8 -*-
"""
Webscraper

Created on Sun Jan 25 12:15:00 2015

@author: Owner

utility functions for scraping a website
"""

import httplib2 as hl
import HTMLParser as hp
import re
import json

class Course:
    #Course object for storing course info
    def __init__(self,step=0,code = ''):
        self.data = {}
        self.data['code'] = code
        #Step: 1=have code, 2=have name, 3=have description
        self.step = step
        self.data['description'] = ''
        self.data['name'] = ''
        self.data['LEC'] = 0
        self.data['TUT'] = 0
        self.data['PRA'] = 0
        self.data['SEM'] = 0
    
    def add_to_desc(self, data):
        #Append string 'data' to 'description'
        self.data['description'] += data
    
    def set_field(self, field, data):
        self.data[field] = data

    def get_field(self, field):
        return self.data[field]
    
    def get_data(self):
        return self.data

class CalendarPageParser(hp.HTMLParser):
    def fetch_url(self,url):
        #Get html from website with url = url
        h = hl.Http(".cache")
        (resp, content) = h.request(url,
                        headers={'cache-control':'no-cache'} )
        self.active_course = Course()
        self.has_active_course = 0;
        self.courses = []
        self.temp_string = ''
        self.url = url #for debug
        self.feed(content)
        
    def read_from_file(self,filename):
        content = open(filename).read()
        self.active_course = Course()
        self.has_active_course = 0;
        self.courses = []
        self.temp_string = ''
        self.feed(content)
            
    def handle_starttag(self, tag, attrs):
        #Look to see if the start tag is a course code
        course_code = dict([item for item in attrs if item[0] == 'name' and re.match('[a-zA-Z]{3}[0-9]{3}[a-zA-Z]{1}[0-9]{1}',item[1])])
#        print "Encountered a start tag:", tag, "with attributes", attrs, "and course_code", course_code
        if tag == 'a' and [item for item in attrs if item[0] == 'name']:
            #'a' tag and 'name' field implies new section; send current course to list and create new course
            if self.has_active_course:
                self.courses.append(self.active_course)
            #Create new course object and set active flag
            if course_code:
                #Make sure course does nto already exist
                duplicate = 0
                for course in self.courses:
                    if course.get_field('code') == course_code['name']:
                        duplicate = 1
                if duplicate:
                    self.active_course = Course(0)
                    self.has_active_course = 0
                else:
                    self.active_course = Course(1,course_code['name'])
                    self.has_active_course = 1
            else:
                self.active_course = Course(0)
                self.has_active_course = 0
        elif self.active_course.step == 2 and tag != 'p':
            #If inside descrption, reconstruct tag and add to description
            self.active_course.add_to_desc(self.get_starttag_text())
        elif tag == 'div': 
            #Handle end of document
            if self.has_active_course:
                self.courses.append(self.active_course)
            self.active_course = Course()
            self.has_active_course = 0
        elif self.active_course.step == 3 and tag != 'br':
            #Handle post-description data
            self.temp_string += self.get_starttag_text()
        elif self.active_course.step == 3:
            #Process section and create new section
            self.process_additional_data_string()
            self.temp_string = ''

    def handle_endtag(self, tag):
        if self.active_course.step == 1 and tag == 'span':
            self.active_course.step = 2
        elif self.active_course.step == 2 and tag == 'p':
            self.active_course.step = 3
        elif self.active_course.step == 2 and tag != 'p':
            self.active_course.add_to_desc('</' + tag + '>')
        elif self.active_course.step == 3:
            self.temp_string += ('</' + tag + '>')
            
    def handle_data(self, data):
#        print "Encountered some data  :", data
        if self.active_course.step == 1:
            #Get LPT info and remove it from string
            if re.search('\[(([0-9]+L)|([0-9]+S)|([0-9]+P)|([0-9]+T)).*\]$', data):
                #Found LPTS info
                LPTS_info = re.search('\[(([0-9]+L)|([0-9]+S)|([0-9]+P)|([0-9]+T)).*\]$', data).group(0)
                #Strip square brackets
                LPTS_info = LPTS_info.replace('[','')
                LPTS_info = LPTS_info.replace(']','')
                #Split according to slash
                LPTS_list = re.split('/|,',LPTS_info)
                for item in LPTS_list:
                    if item[-1] == 'L':
                        self.active_course.set_field('LEC',int(item[0:-1]))
                    elif item[-1] == 'T':
                        self.active_course.set_field('TUT',int(item[0:-1]))
                    elif item[-1] == 'S':
                        self.active_course.set_field('SEM',int(item[0:-1]))
                    elif item[-1] == 'P':
                        self.active_course.set_field('PRA',int(item[0:-1]))
                data = data.replace(re.search('\[(([0-9]+L)|([0-9]+S)|([0-9]+P)|([0-9]+T)).*\]$', data).group(0),'')

            elif re.search('\[TBA\]$', data):
                #Hit "[TBA]"
                self.active_course.set_field('LEC',-1)
                self.active_course.set_field('TUT',-1)
                self.active_course.set_field('PRA',-1)
                self.active_course.set_field('SEM',-1)
                data = data.replace('[TBA]','')
                
            self.active_course.set_field('name', data)
        elif self.active_course.step == 2:
            self.active_course.add_to_desc(data)
        elif self.active_course.step == 3:
            self.temp_string += data

    def process_additional_data_string(self):
        category_data_pair = self.temp_string.split(':',1)
        if len(category_data_pair) > 1:
            category = category_data_pair[0].replace('<p>','')
            data = category_data_pair[1]
            self.active_course.set_field(category,data.strip())        
            
    def get_course_data(self):
        courses = {}
        #Returns a json string of the courses
        for course in self.courses:
            courses[course.get_field('code')] = course.get_data()
        return courses
    
    def output_json_string(self):
        courses_list = []
        #Returns a json string of the courses
        for course in self.courses:
            courses_list.append(course.get_data())
        return json.dumps(courses_list)
    
    def write_to_file(self,filename):
        #Writes json of courses to file with name = filename
        out_file = open(filename, 'wb')
        out_file.write(self.output_json_string())
        out_file.close

class TimetableParser(hp.HTMLParser):
    def fetch_url(self,url):
        #Get html from website with url = url
        h = hl.Http(".cache")
        (resp, content) = h.request(url,
                        headers={'cache-control':'no-cache'} )
        self.url = url #for debug
        self.in_table = 0
        self.finished = 0
        self.in_row = 0
        self.in_col = 0
        self.rows = []
        self.feed(content)
        
    def read_from_file(self,filename):
        content = open(filename).read()
        self.in_table = 0
        self.finished = 0
        self.in_row = 0
        self.in_col = 0
        self.feed(content)
            
    def handle_starttag(self, tag, attrs):
        #Look to see if the start tag is a course code
#        print "Encountered a start tag:", tag, "with attributes", attrs, "and course_code", course_code
        if tag == 'table':
            if self.finished == 0:
                self.in_table = 1
        elif self.in_table and tag == 'tr':
            #Start new row
            self.in_row = 1
            self.cols = []
        elif self.in_table and self.in_row and tag == 'td':
            #If there is a colspan, insert colspan-1 dummy columns
            colspan = [item for item in attrs if item[0] == 'colspan']
            if colspan:
                for i in range(int(colspan[0][1])-1):
                    self.cols.append
                    self.cols.append('')
            #Start new column
            self.in_col = 1
            self.current_col = ''
        elif self.in_table and self.in_row and self.in_col:
            #Append current tag to current cell
            if tag == 'a':
                self.current_col += self.get_starttag_text()

    def handle_endtag(self, tag):
        if tag == 'table':            
            self.finished = 1
            self.in_table = 0
        elif self.in_table and tag == 'tr':
            #Append current row to rows
            self.in_row = 0
            self.rows.append(self.cols)
        elif self.in_table and tag == 'td':
            #Append current col to cols
            self.in_col = 0
            self.cols.append(self.current_col)
        elif self.in_table and self.in_row and self.in_col:
            #Append current tag to current cell
            if tag == 'a':
                self.current_col += ('</' + tag + '>')
            
    def handle_data(self, data):
#        print "Encountered some data  :", data
        if self.in_table and self.in_row and self.in_col:
            #add data to current cell
            self.current_col += data

    def process_rows(self):
        #print self.url
        self.courses = {}
        self.current_code = ''
        self.current_section = ''
        self.in_data = 0
        for row in self.rows:
            if re.match('<a',row[0]):
                self.in_data = 1
            if self.in_data:
                #Look for course code
                if re.match('<a',row[0]):
                    code_match = re.search('>[a-zA-Z]{3}[0-9]{3}[a-zA-Z]{1}[0-9]{1}<',row[0])
                    if code_match:
                        #Initialize new entry
                        self.current_code = code_match.group(0)[1:-1]
                        self.courses[self.current_code] = {'SC':row[1],'name':row[2],'sections':{}}
                #Look for section code
                if row[3]:
                    #Get just the section name
                    if re.match('[PTL][0-9]{4}',row[3]):
                        self.current_section = re.match('[PTL][0-9]{4}',row[3]).group(0)
                        self.courses[self.current_code]['sections'][self.current_section] = [row[4],row[8],row[7],[]]
                #Find lecture times
                if row[5]:
                    #[5]=time,[6]=loc,[7]=prof
                    #Get individual lecture times
                    times = []
                    if row[5] != 'TBA':
                        times_list = re.findall('[MTWRF]{1,5}[0-9\-]{1,5}',row[5])
                        for time in times_list:
                            days =  re.findall('[MTWRF]{1}',time)
                            hours_string = re.findall('[0-9\-]+',time)[0]
                            if '-' in hours_string:
                                hours = tuple(hours_string.split('-'))
                            else:
                                hours = (hours_string,str(int(hours_string)%12+1))
                            for day in days:
                                times.append(tuple(day)+hours)
                    else:
                        times = ['TBA']
                        
                    self.courses[self.current_code]['sections'][self.current_section][3].append(tuple([row[6]])+tuple(times))
                    
                #Deal with cancelled class
                if len(row)>8 and row[8] == 'Cancel':
                    self.courses[self.current_code]['sections'][self.current_section] = ['Cancel']
                
        return self.courses

    def output_json_string(self):
        #Returns a json string of the courses
        return json.dumps(self.courses)
    
    def write_to_file(self,filename):
        #Writes json of courses to file with name = filename
        self.process_rows()
        out_file = open(filename, 'wb')
        out_file.write(self.output_json_string())
        out_file.close

class TimetableDirectoryParser(hp.HTMLParser):
    #Parser the master list of timetables from http://www.artsandscience.utoronto.ca/ofr/timetable/winter/sponsors.htm
    def fetch(self):
        #Fetch all timetable info
        #Get html from website
        self.urls = []
        self.base_path_tt = 'http://www.artsandscience.utoronto.ca/ofr/timetable/winter/'
        self.base_path_cd = 'http://www.artsandscience.utoronto.ca/ofr/calendar/crs_'
        self.directory_url = 'http://www.artsandscience.utoronto.ca/ofr/timetable/winter/sponsors.htm'
        self.courses = {}
        h = hl.Http(".cache")
        (resp, content) = h.request(self.directory_url,
                        headers={'cache-control':'no-cache'} )
        self.feed(content)
        
    def handle_starttag(self,tag,attrs):
        link = [item[1] for item in attrs if item[0] == 'href']
        if tag == 'a' and link:
            for url in link:
                if not re.match('http', url) and not re.search('assem',url):
                    self.urls.append(self.base_path_tt + url)
                    
    def process_urls(self):
        #Get all timetable info
        for url in self.urls:
            new_parser = TimetableParser()
            new_parser.fetch_url(url)
            self.courses.update(new_parser.process_rows())
        #Get all course info
        course_codes_visited = []
        for course_code in self.courses.keys():
            if course_code[0:3] not in course_codes_visited:                
                desc_parser = CalendarPageParser()
                desc_parser.fetch_url(self.base_path_cd + course_code[0:3].lower() + '.htm')
                for k,v in desc_parser.get_course_data().iteritems():
                    self.courses.setdefault(k,{}).update(v)
#                self.courses.update(desc_parser.get_course_data())
                course_codes_visited.append(course_code[0:3])

    def output_json_string(self):
        #Returns a json string of the courses
        return json.dumps(self.courses)
    
    def write_to_file(self,filename):
        #Writes json of courses to file with name = filename
        self.process_urls()
        out_file = open(filename, 'wb')
        out_file.write(self.output_json_string())
        out_file.close
    
    def output_json_string_partial(self):
        #Returns a json string of the first 100 courses
        temp_courses = {}
        temp_keys = self.courses.keys()
        for i in range(100):
            temp_courses[temp_keys[i]] = self.courses[temp_keys[i]]
        return json.dumps(temp_courses)
    
    def write_to_file_partial(self,filename):
        #Writes json of the first 100 courses to file with name = filename
        self.process_urls()
        out_file = open(filename, 'wb')
        out_file.write(self.output_json_string_partial())
        out_file.close


class TestParser(hp.HTMLParser):
    def handle_starttag(self,tag,attrs):
        print attrs
        
#TODO: assem doesn't work - different format
        
if __name__ == '__main__':
    x = TimetableDirectoryParser()
    x.fetch()
    x.write_to_file_partial('master_timetable_partial.json')
    x.write_to_file('master_timetable.json')