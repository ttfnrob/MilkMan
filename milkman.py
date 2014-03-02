from minimongo import Model, Index
from numpy import recfromcsv
import os
import glob

class Subject(Model):
    class Meta:
        database = "milky_way"
        collection = "milky_way_subjects"

        indices = (
            Index("zooniverse_id"),
            Index("coords"),
        )

class Classification(Model):
    class Meta:
        database = "milky_way"
        collection = "milky_way_classifications"

        indices = (
            Index("subject_ids"),
        )

recent = '/Users/Rob/Projects/MilkMan/data/raw/annotations/galaxy_raw_20140107131329.csv'
my_data = recfromcsv(recent, delimiter=',', filling_values='', case_sensitive=True, deletechars='', replace_space=' ')

# s = Subject.collection.find_one({"zooniverse_id": "AMW0000tvp"})
# print s.location.standard, s.metadata.markings.blank_count
