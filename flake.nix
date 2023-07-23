{
  outputs = { ... }: {
    value = "";
    extract = prefix: inputs:
      let
        keys = builtins.filter (attr:
          (builtins.substring 0 (builtins.stringLength prefix) attr) == prefix)
          (builtins.attrNames inputs);
        getUntilPivot = lst:
          if lst == [ ] then
            lst
          else
            let
              head = builtins.head lst;
              attr = builtins.getAttr head inputs;
            in if (attr == null || attr == ""
              || !(builtins.hasAttr "value" attr) || attr.value == null
              || attr.value == "") then
              [ ]
            else
              [ attr.value ] ++ (getUntilPivot (builtins.tail lst));
      in builtins.foldl' (x: y: x + y) "" (getUntilPivot keys);
  };
}
