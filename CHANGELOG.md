## 0.0.1

* Initial Release

# 0.0.5

* readOnly field treatment

# 0.0.8
added translations via flutter_i18n and default field
* translations 
Set 'translate: true' to activate. The fields title and description can be used to store the key to be translated. 
If translate is set to true but no title or description is given the key will be generated from the 
title in the root and the keys that are listed in the properties.
* default field
The value of the default needs to correspond with the type of field. String, number or bool.
When the 'enum' field is used the default value needs to be one of the values in that field. 
