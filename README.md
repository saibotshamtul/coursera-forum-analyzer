# Coursera Forum Analyzer
Get staff coverage stats on a peer-week basis.

## Dependencies
```
gem install nokogiri selenium-webdriver
```

## Usage
1. Open your default Firefox profile instance, login through Coursera and make sure you don't logout
2. Add all the direct links to the forums subsections you want to test in the ```SUB_FORUMS``` list in ```analyzer.rb```
3. ```ruby analyzer.rb```

## Results

```
--------------------------------------------------------------------
 Forum Stats @ 2015-06-02 00:07:01 UTC:

> Sub-forum "Week 1" has 41 threads, 21 staff-replied (52%)
> Sub-forum "Week 2" has 47 threads, 16 staff-replied (35%)
> Sub-forum "Week 3" has 23 threads, 11 staff-replied (48%)
> Sub-forum "Week 4" has 28 threads, 13 staff-replied (47%)
> Sub-forum "Week 5" has 22 threads, 11 staff-replied (50%)
> Sub-forum "Week 6" has 19 threads, 11 staff-replied (58%)
> Sub-forum "Week 7" has 1 threads, 0 staff-replied (0%)
> Sub-forum "Urgent Matters & Technical Issues" has 81 threads, 52 staff-replied (65%)
> Sub-forum "Project Websites" has 40 threads, 9 staff-replied (23%)
> Sub-forum "Share Your Project" has 125 threads, 14 staff-replied (12%)
> Sub-forum "Connect with Classmates" has 81 threads, 16 staff-replied (20%)

 Total: 508 threads, 174 staff-replied (35% coverage)
--------------------------------------------------------------------
```

## Notes
* This tool is intended to be used by (C)TAs only, NOT students!
* The author of this tool is not responsible of any consequences you might face using it (such as having your account locked or removed)
* Please always check an updated version of the Coursera TOS before using this
* In any case, do not abuse of the tool.
