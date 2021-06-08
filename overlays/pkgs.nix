final: prev: {
  pure-prompt = prev.pure-prompt.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./pure-zsh.patch ];
  });
}
