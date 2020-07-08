{
  enable = true;
  settings = {
    env = { TERM = "xterm-256color"; };

    window = {
      dimensions = {
        columns = 160;
        lines = 40;
      };

      padding = {
        x = 2;
        y = 2;
      };

      dynamic_padding = false;
      decorations = "buttonless";
    };

    font = {
      normal = {
        family = "CozetteVector";
        style = "Regular";
      };
      bold = {
        family = "CozetteVector";
        style = "Regular";
      };
      italic = {
        family = "CozetteVector";
        style = "Regular";
      };
      size = 14.0;
    };

    colors = {
      bright = {
        black = "#bdbdbd";
        blue = "#b1d8f6";
        cyan = "#1ab2a8";
        green = "#bddeab";
        magenta = "#fbdaff";
        red = "#ffa1a1";
        white = "#ffffff";
        yellow = "#ffdca0";
      };
      cursor = {
        cursor = "#ffa560";
        text = "#ffffff";
      };
      normal = {
        black = "#929292";
        blue = "#97bedc";
        cyan = "#00988e";
        green = "#94b979";
        magenta = "#e1c0fa";
        red = "#e27373";
        white = "#dedede";
        yellow = "#ffba7b";
      };
      primary = {
        background = "#121212";
        foreground = "#dedede";
      };
      selection = {
        background = "#474e91";
        text = "#f4f4f4";
      };
    };
  };
}
