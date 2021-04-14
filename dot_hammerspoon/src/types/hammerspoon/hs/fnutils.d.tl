local record fnutils
  find: function <K, V> ({K : V}, function(V): boolean):  V
  find : function <V> ({V}, function(V): boolean): V
end

return fnutils
