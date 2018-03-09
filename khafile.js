let project = new Project('10UpInterdimensionalLiquids');
project.addSources('Sources');

project.addAssets('Assets/Blobs/*');
project.addAssets('Assets/Fonts/*');
project.addAssets('Assets/Sounds/*');
project.addAssets('Assets/Graphics/*');

project.addAssets('Assets/Graphics2x/*', {
	scale: 2.0,
	background: {
    	red: 255,
    	green: 174,
    	blue: 201
	}
});

project.addAssets('Assets/GraphicsStencil/*', {
	background: {
    	red: 255,
    	green: 174,
    	blue: 201
	}
});

project.addLibrary('Kha2D');
resolve(project);
