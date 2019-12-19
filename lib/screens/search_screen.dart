import 'package:flutter/material.dart';
import 'package:spoonacular_app/model/meal_plan_model.dart';
import 'package:spoonacular_app/services/api_services.dart';

import 'meals_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /*
  Our state has three parameters.
  diets - list of diet that the spoonacular api let's us filter by,
  targetCalories - desired number of calories we want our mealplan to reach
  diet - our selected diet
  */

  List<String> _diets = [
    //List of diets that lets spoonacular filter
    'None',
    'Gluten Free',
    'Ketogenic',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Whole30',
  ];

  double _targetCalories = 2250;
  String _diet = 'None';

  @override

  //This method generates a MealPlan by parsing our parameters into the 
  //ApiService.instance.generateMealPlan.
  //It then pushes the Meal Screen onto the stack with Navigator.push
  void _searchMealPlan() async {
    MealPlan mealPlan = await ApiService.instance.generateMealPlan(
      targetCalories: _targetCalories.toInt(),
      diet: _diet,
    );
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => MealsScreen(mealPlan: mealPlan),
    ));
  }

  
  Widget build(BuildContext context) {
    /*
    Our build method returns Scaffold Container, which has a decoration
    image using a Network Image. The image loads and is the background of 
    the page
    */
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=353&q=80'),
            fit: BoxFit.cover,
          ),
        ),

        //Center widget and a container as a child, and a column widget
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Text widget for our app's title
                Text(
                    'My Daily Meal Planner',
                    style: TextStyle(fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                  ),
                  //space
                  SizedBox(height: 20),
                  //A RichText to style the target calories
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.body1.copyWith(fontSize: 25),
                      children: [
                        TextSpan(
                          text:  _targetCalories.truncate().toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                          text: 'cal',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ]
                    ),
                  ),
                  //Orange slider that sets our target calories
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Colors.lightBlue[100],
                      trackHeight: 6,
                    ),
                    child: Slider(
                      min: 0,
                      max: 4500,
                      value: _targetCalories,
                      onChanged: (value) => setState(() {
                        _targetCalories = value.round().toDouble();
                      }
                      ),
                    ),
                  ),
                  //Simple drop down to select the type of diet
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownButtonFormField(
                      items: _diets.map((String priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(
                            priority,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Diet',
                        labelStyle: TextStyle(fontSize: 18),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _diet = value;
                        });
                      },
                      value: _diet,
                    ),
                  ),
                  //Space
                  SizedBox(height: 30),
                  //FlatButton where onPressed() triggers a function called _searchMealPlan
                  FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Search', style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                    //_searchMealPlan function is above the build method
                    onPressed: _searchMealPlan,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
